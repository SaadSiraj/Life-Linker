import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lifelinker/core/constants/web_rtc_const.dart';
import 'package:lifelinker/model/ice_candidate.dart';
import 'package:lifelinker/model/web_rtc_session.dart';
import 'package:lifelinker/repository/web_rtc_signaling_repo.dart';

enum CaregiverStreamState { idle, connecting, watching, error, patientOffline }

class CaregiverStreamProvider extends ChangeNotifier {
  RTCPeerConnection? _peerConnection;
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  CaregiverStreamState _state = CaregiverStreamState.idle;
  String? _errorMessage;
  String? _activeSessionId;
  bool _hasRemoteStream = false;

  StreamSubscription<WebRtcSessionModel?>? _sessionSub;
  StreamSubscription<List<IceCandidateModel>>? _callerCandidateSub;

  final Set<String> _addedCandidateKeys = {};

  CaregiverStreamState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isWatching => _state == CaregiverStreamState.watching;
  bool get isConnecting => _state == CaregiverStreamState.connecting;
  bool get hasRemoteStream => _hasRemoteStream;
  bool get isPatientOffline => _state == CaregiverStreamState.patientOffline;
  RTCVideoRenderer get renderer => remoteRenderer;

  bool _isPaused = false;
  bool get isPaused => _isPaused;
  Timer? _connectingTimer;
  bool _timedOut = false;
  bool get hasTimedOut => _timedOut;

  Future<void> pauseWatching() async {
    _isPaused = true;
    await stopWatching();
    notifyListeners();
  }

  Future<void> resumeWatching({
    required String patientId,
    required String caregiverId,
  }) async {
    _isPaused = false;
    _timedOut = false;
    await startWatching(patientId: patientId, caregiverId: caregiverId);
  }

  Future<void> startWatching({
    required String patientId,
    required String caregiverId,
  }) async {
    _timedOut = false;
    _connectingTimer?.cancel();

    // KEY FIX: clean up any stale session first
    await _cleanStaleSession(patientId: patientId, caregiverId: caregiverId);

    if ((_state == CaregiverStreamState.connecting ||
            _state == CaregiverStreamState.watching) &&
        _peerConnection != null) {
      return;
    }

    _setState(CaregiverStreamState.connecting);
    _errorMessage = null;
    _hasRemoteStream = false;

    try {
      await remoteRenderer.initialize();

      _activeSessionId = '${patientId}_$caregiverId';

      await WebRtcSignalingRepository.createSession(
        patientId: patientId,
        caregiverId: caregiverId,
      );

      _listenToSession(patientId, caregiverId);
      _connectingTimer = Timer(const Duration(seconds: 15), () {
        if (!isWatching || !hasRemoteStream) {
          _timedOut = true;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('[CaregiverStream] startWatching error: $e');
      _setError('Failed to initialize: $e');
    }
  }

  Future<void> _cleanStaleSession({
    required String patientId,
    required String caregiverId,
  }) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('webrtc_sessions')
          .where('patientId', isEqualTo: patientId)
          .where('caregiverId', isEqualTo: caregiverId)
          .where('status', isEqualTo: 'waiting')
          .get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } catch (_) {}
  }

  void _listenToSession(String patientId, String caregiverId) {
    if (_activeSessionId == null) return;
    _sessionSub?.cancel();

    _sessionSub = WebRtcSignalingRepository.listenToSession(_activeSessionId!)
        .listen((session) async {
          if (session == null) {
            _setState(CaregiverStreamState.patientOffline);
            return;
          }

          if (session.isEnded) {
            await _teardown();
            _setState(CaregiverStreamState.patientOffline);
            return;
          }

          if (session.offer != null) {
            if (_peerConnection == null) {
              await _handleOffer(session.offer!);
            } else {
              // Patient ne reconnect kiya — tear down and re-handle
              final sigState = await _peerConnection!.getSignalingState();
              if (sigState == RTCSignalingState.RTCSignalingStateStable &&
                  !_hasRemoteStream) {
                await _teardown();
                await _handleOffer(session.offer!);
              }
            }
          }
        });
  }

  Future<void> _handleOffer(Map<String, dynamic> offerMap) async {
    if (_activeSessionId == null) return;
    debugPrint('[CaregiverStream] Handling offer from patient');
    try {
      _peerConnection = await createPeerConnection(
        WebRtcConstants.rtcConfiguration,
      );

      _peerConnection!.onTrack = (RTCTrackEvent event) {
        debugPrint(
          '[CaregiverStream] Remote track received — streams: ${event.streams.length}',
        );
        if (event.streams.isNotEmpty) {
          remoteRenderer.srcObject = event.streams.first;
          _hasRemoteStream = true;
          _setState(CaregiverStreamState.watching);
          debugPrint('[CaregiverStream] Remote stream set on renderer ✅');
        }
      };

      _peerConnection!.onConnectionState = (state) {
        debugPrint('[CaregiverStream] Connection state: $state');
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
            state ==
                RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
          _hasRemoteStream = false;
          _setState(CaregiverStreamState.patientOffline);
        }
      };

      _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) async {
        if (candidate.candidate == null) return;
        debugPrint('[CaregiverStream] ICE candidate generated');
        await WebRtcSignalingRepository.addCalleeCandidate(
          sessionId: _activeSessionId!,
          candidate: IceCandidateModel(
            candidate: candidate.candidate!,
            sdpMid: candidate.sdpMid ?? '',
            sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
          ),
        );
      };

      final offer = RTCSessionDescription(offerMap['sdp'], offerMap['type']);
      await _peerConnection!.setRemoteDescription(offer);
      debugPrint('[CaregiverStream] Remote description set');

      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);
      debugPrint('[CaregiverStream] Answer created');

      await WebRtcSignalingRepository.saveAnswer(
        sessionId: _activeSessionId!,
        answer: {'type': answer.type, 'sdp': answer.sdp},
      );
      debugPrint('[CaregiverStream] Answer saved to Firestore ✅');

      _listenForCallerCandidates();
    } catch (e, stack) {
      debugPrint('[CaregiverStream] _handleOffer error: $e\n$stack');
      _setError('Connection error: $e');
    }
  }

  void _listenForCallerCandidates() {
    if (_activeSessionId == null) return;
    _callerCandidateSub?.cancel();

    _callerCandidateSub =
        WebRtcSignalingRepository.listenToCallerCandidates(
          _activeSessionId!,
        ).listen((candidates) async {
          for (final c in candidates) {
            final key = '${c.candidate}_${c.sdpMid}';
            if (_addedCandidateKeys.contains(key)) continue;
            _addedCandidateKeys.add(key);

            try {
              await _peerConnection?.addCandidate(
                RTCIceCandidate(c.candidate, c.sdpMid, c.sdpMLineIndex),
              );
            } catch (e) {
              debugPrint('[CaregiverStream] addCandidate error: $e');
            }
          }
        });
  }

  Future<void> stopWatching() async {
    _connectingTimer?.cancel();
    _timedOut = false;
    await _teardown();
    _setState(CaregiverStreamState.idle);
  }

  Future<void> _teardown() async {
    _sessionSub?.cancel();
    _callerCandidateSub?.cancel();
    _sessionSub = null;
    _callerCandidateSub = null;
    _addedCandidateKeys.clear();

    remoteRenderer.srcObject = null;

    try {
      await _peerConnection?.close();
    } catch (_) {}
    _peerConnection = null;
    _hasRemoteStream = false;
  }

  void _setState(CaregiverStreamState state) {
    _state = state;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = CaregiverStreamState.error;
    notifyListeners();
  }

  @override
  void dispose() {
    _teardown();
    remoteRenderer.dispose();
    super.dispose();
  }
}
