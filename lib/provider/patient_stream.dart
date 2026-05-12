import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lifelinker/core/constants/web_rtc_const.dart';
import 'package:lifelinker/model/ice_candidate.dart';
import 'package:lifelinker/model/web_rtc_session.dart';
import 'package:lifelinker/repository/web_rtc_signaling_repo.dart';

enum PatientStreamState { idle, initializing, streaming, error }

class PatientStreamProvider extends ChangeNotifier {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();

  PatientStreamState _state = PatientStreamState.idle;
  String? _errorMessage;
  String? _activeSessionId;

  StreamSubscription<WebRtcSessionModel?>? _sessionSub;
  StreamSubscription<List<IceCandidateModel>>? _calleeCandidateSub;

  bool _answerApplied = false;
  final Set<String> _addedCandidateKeys = {};

  PatientStreamState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isStreaming => _state == PatientStreamState.streaming;
  bool get isInitializing => _state == PatientStreamState.initializing;
  RTCVideoRenderer get renderer => localRenderer;
  bool _isPaused = false;
  bool get isPaused => _isPaused;
  Timer? _connectingTimer;
  bool _timedOut = false;
  bool get hasTimedOut => _timedOut;

  Future<void> pauseStreaming() async {
    _isPaused = true;
    await stopStreaming();
    notifyListeners();
  }

  Future<void> resumeStreaming({
    required String patientId,
    required String caregiverId,
  }) async {
    _isPaused = false;
    _timedOut = false;
    await startStreaming(patientId: patientId, caregiverId: caregiverId);
  }

  Future<void> startStreaming({
    required String patientId,
    required String caregiverId,
  }) async {
    _timedOut = false;
    // Cancel old timer
    _connectingTimer?.cancel();

    // If already streaming, skip
    if (isStreaming) return;

    if (_state == PatientStreamState.streaming ||
        _state == PatientStreamState.initializing)
      return;

    debugPrint(
      '[PatientStream] startStreaming — patientId: $patientId, caregiverId: $caregiverId',
    );

    if (patientId.isEmpty || caregiverId.isEmpty) {
      debugPrint('[PatientStream] ABORT — empty IDs');
      return;
    }

    _setState(PatientStreamState.initializing);
    _answerApplied = false;
    _addedCandidateKeys.clear();
    _activeSessionId = '${patientId}_$caregiverId';

    try {
      await localRenderer.initialize();
      debugPrint('[PatientStream] Renderer initialized');

      _localStream = await navigator.mediaDevices.getUserMedia(
        WebRtcConstants.mediaConstraints,
      );
      localRenderer.srcObject = _localStream;
      debugPrint('[PatientStream] Camera stream acquired ✅');

      // Always reset session first — ensures clean state on restart/reconnect
      await WebRtcSignalingRepository.resetSessionByPatient(
        patientId: patientId,
        caregiverId: caregiverId,
      );
      debugPrint('[PatientStream] Session reset ✅');

      // Listen for caregiver answer (reactive)
      _listenForSession();

      // Create and send offer immediately
      await _createAndSendOffer();
      _connectingTimer = Timer(const Duration(seconds: 15), () {
        if (!isStreaming) {
          _timedOut = true;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('[PatientStream] startStreaming error: $e');
      _setError(e.toString());
    }
  }

  void _listenForSession() {
    if (_activeSessionId == null) return;
    _sessionSub?.cancel();

    _sessionSub = WebRtcSignalingRepository.listenToSession(_activeSessionId!)
        .listen((session) async {
          if (session == null) return;

          debugPrint(
            '[PatientStream] Session update — status: ${session.status}, '
            'answer: ${session.answer != null}',
          );

          if (session.isEnded) {
            debugPrint('[PatientStream] Session ended by caregiver');
            _setState(PatientStreamState.initializing);
            return;
          }

          if (session.answer != null &&
              !_answerApplied &&
              _peerConnection != null) {
            debugPrint('[PatientStream] Answer arrived — applying');
            await _applyAnswer(session.answer!);
          }
        });
  }

  Future<void> _createAndSendOffer() async {
    if (_activeSessionId == null || _localStream == null) return;

    try {
      await _peerConnection?.close();
      _peerConnection = null;

      _peerConnection = await createPeerConnection(
        WebRtcConstants.rtcConfiguration,
      );
      debugPrint('[PatientStream] Peer connection created');

      for (final track in _localStream!.getTracks()) {
        await _peerConnection!.addTrack(track, _localStream!);
      }
      debugPrint('[PatientStream] Tracks added');

      _peerConnection!.onConnectionState = (state) {
        debugPrint('[PatientStream] Connection state: $state');
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
          _setState(PatientStreamState.streaming);
        } else if (state ==
                RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
            state ==
                RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
          debugPrint('[PatientStream] Connection lost — back to initializing');
          _setState(PatientStreamState.initializing);
        }
      };

      _peerConnection!.onIceCandidate = (candidate) async {
        if (candidate.candidate == null) return;
        await WebRtcSignalingRepository.addCallerCandidate(
          sessionId: _activeSessionId!,
          candidate: IceCandidateModel(
            candidate: candidate.candidate!,
            sdpMid: candidate.sdpMid ?? '0',
            sdpMLineIndex: candidate.sdpMLineIndex ?? 0,
          ),
        );
      };

      final offer = await _peerConnection!.createOffer(
        WebRtcConstants.offerSdpConstraints,
      );
      await _peerConnection!.setLocalDescription(offer);
      debugPrint('[PatientStream] Local description set');

      await WebRtcSignalingRepository.saveOffer(
        sessionId: _activeSessionId!,
        offer: {'type': offer.type, 'sdp': offer.sdp},
      );
      debugPrint('[PatientStream] Offer saved to Firestore ✅');

      _listenForCalleeCandidates();
    } catch (e) {
      debugPrint('[PatientStream] _createAndSendOffer error: $e');
      _setError(e.toString());
    }
  }

  Future<void> _applyAnswer(Map<String, dynamic> answerMap) async {
    if (_answerApplied || _peerConnection == null) return;

    final signalingState = await _peerConnection!.getSignalingState();
    debugPrint(
      '[PatientStream] Signaling state before answer: $signalingState',
    );

    if (signalingState == RTCSignalingState.RTCSignalingStateStable) {
      debugPrint('[PatientStream] Already stable — skipping');
      return;
    }

    try {
      _answerApplied = true;
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(answerMap['sdp'], answerMap['type']),
      );
      debugPrint('[PatientStream] Answer applied ✅');
    } catch (e) {
      _answerApplied = false;
      debugPrint('[PatientStream] setRemoteDescription error: $e');
    }
  }

  void _listenForCalleeCandidates() {
    if (_activeSessionId == null) return;
    _calleeCandidateSub?.cancel();

    _calleeCandidateSub =
        WebRtcSignalingRepository.listenToCalleeCandidates(
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
              debugPrint('[PatientStream] Callee ICE candidate added');
            } catch (e) {
              debugPrint('[PatientStream] addCandidate error: $e');
            }
          }
        });
  }

  Future<void> stopStreaming() async {
    _connectingTimer?.cancel();
    _timedOut = false;
    debugPrint('[PatientStream] stopStreaming called');
    _sessionSub?.cancel();
    _calleeCandidateSub?.cancel();
    _sessionSub = null;
    _calleeCandidateSub = null;
    _answerApplied = false;
    _addedCandidateKeys.clear();

    _localStream?.getTracks().forEach((t) => t.stop());
    _localStream?.dispose();
    _localStream = null;

    try {
      await _peerConnection?.close();
    } catch (_) {}
    _peerConnection = null;

    localRenderer.srcObject = null;
    _activeSessionId = null;

    _setState(PatientStreamState.idle);
  }

  void _setState(PatientStreamState state) {
    _state = state;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = PatientStreamState.error;
    notifyListeners();
  }

  @override
  void dispose() {
    stopStreaming();
    localRenderer.dispose();
    super.dispose();
  }
}
