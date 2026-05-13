import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:lifelinker/core/config/face_recognition_config.dart';
import 'package:lifelinker/core/services/face_tts_service.dart';
import 'package:lifelinker/model/face_match_resesult.dart';
import 'package:lifelinker/repository/face_recognition_repo.dart';

class FaceRecognitionProvider extends ChangeNotifier {
  final _repository = FaceRecognitionRepository();
  final _ttsService = FaceTtsService();

  CameraController? _cameraController;
  Timer? _captureTimer;

  // ── State ─────────────────────────────────────────────────────────────────
  FaceRecognitionStatus _status = FaceRecognitionStatus.idle;
  FaceMatchResult? _lastResult;
  String? _errorMessage;
  bool _isProcessing = false;
  int _totalScans = 0;
  int _totalMatches = 0;

  // Cooldown tracking
  String? _lastAnnouncedUserId;
  DateTime? _lastAnnouncementTime;

  // ── Getters ───────────────────────────────────────────────────────────────
  FaceRecognitionStatus get status => _status;
  FaceMatchResult? get lastResult => _lastResult;
  String? get errorMessage => _errorMessage;
  bool get isActive => _captureTimer?.isActive ?? false;
  int get totalScans => _totalScans;
  int get totalMatches => _totalMatches;
  int get loadedUsersCount => _repository.userCount;

  bool get isIdle => _status == FaceRecognitionStatus.idle;
  bool get isScanning => _status == FaceRecognitionStatus.scanning;
  bool get isDetecting => _status == FaceRecognitionStatus.detected;
  bool get hasMatch => _status == FaceRecognitionStatus.matched;
  bool get hasNoMatch => _status == FaceRecognitionStatus.noMatch;
  bool get hasError => _status == FaceRecognitionStatus.error;

  // ── Initialize ────────────────────────────────────────────────────────────
  Future<void> initialize({
    required String patientId,
    required String? caregiverId,
  }) async {
    if (_status != FaceRecognitionStatus.idle) {
      debugPrint('[FaceProvider] Already initialized or running — skip');
      return;
    }

    _setStatus(FaceRecognitionStatus.scanning);
    _errorMessage = null;

    debugPrint('\n╔══════════════════════════════════════╗');
    debugPrint('║   FACE RECOGNITION — STARTING UP     ║');
    debugPrint('╚══════════════════════════════════════╝\n');

    try {
      // Step 1: TTS init
      await _ttsService.initialize();
      debugPrint('[FaceProvider] Step 1/3: TTS ready ✅');

      // Step 2: Load known users from Firestore
      await _repository.loadKnownUsers(
        patientId: patientId,
        caregiverId: caregiverId,
      );
      debugPrint(
        '[FaceProvider] Step 2/3: Loaded ${_repository.userCount} users ✅',
      );

      if (!_repository.hasKnownUsers) {
        debugPrint(
          '[FaceProvider] ⚠️ No users with profile images found!'
          ' Face recognition disabled.',
        );
        _setStatus(FaceRecognitionStatus.error);
        _errorMessage = 'No profile images found';
        return;
      }

      // Step 3: Camera init
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No camera available');
      }

      // Front camera prefer karo (patient khud samne hoga)
      final selectedCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        ),
      );

      debugPrint(
        '[FaceProvider] Using camera: ${selectedCamera.lensDirection.name}',
      );

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium, // medium = good quality for face recognition
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();
      debugPrint('[FaceProvider] Step 3/3: Camera ready ✅');

      // Start capture loop
      _startCaptureLoop();

      debugPrint('\n[FaceProvider] 🚀 Face recognition ACTIVE');
      debugPrint(
        '[FaceProvider] Interval: ${FaceRecognitionConfig.captureIntervalSeconds}s',
      );
      debugPrint(
        '[FaceProvider] Threshold: ${FaceRecognitionConfig.matchThreshold}%',
      );
      debugPrint('[FaceProvider] Users loaded: ${_repository.userCount}\n');

      _setStatus(FaceRecognitionStatus.scanning);
    } catch (e) {
      debugPrint('[FaceProvider] ❌ Init error: $e');
      _errorMessage = e.toString();
      _setStatus(FaceRecognitionStatus.error);
    }
  }

  // ── Capture Loop ──────────────────────────────────────────────────────────
  void _startCaptureLoop() {
    _captureTimer?.cancel();
    _captureTimer = Timer.periodic(
      Duration(seconds: FaceRecognitionConfig.captureIntervalSeconds),
      (_) => _captureAndProcess(),
    );
  }

  Future<void> _captureAndProcess() async {
    if (_isProcessing) {
      debugPrint('[FaceProvider] ⏳ Still processing previous frame — skip');
      return;
    }
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      debugPrint('[FaceProvider] ⚠️ Camera not ready');
      return;
    }

    _isProcessing = true;
    _totalScans++;
    String? capturedPath;

    try {
      debugPrint('\n[FaceProvider] 📸 Scan #$_totalScans — Capturing frame...');

      // Frame capture
      _setStatus(FaceRecognitionStatus.scanning);
      final xFile = await _cameraController!.takePicture();
      capturedPath = xFile.path;

      debugPrint('[FaceProvider] Frame captured: $capturedPath');
      debugPrint('[FaceProvider] 🔍 Sending to Face++ API...');

      // API call
      _setStatus(FaceRecognitionStatus.detected);
      final result = await _repository.findBestMatch(capturedPath);

      _lastResult = result;

      if (result.noFaceDetected) {
        _setStatus(FaceRecognitionStatus.noFace); // ← NEW status
        debugPrint('[FaceProvider] 📷 No face in camera frame');
      } else if (result.isMatch) {
        _totalMatches++;
        _setStatus(FaceRecognitionStatus.matched);
        debugPrint(
          '[FaceProvider] ✅ MATCH: ${result.userName} — ${result.confidenceLabel}',
        );
        await _maybeAnnounce(result);
      } else {
        _setStatus(FaceRecognitionStatus.noMatch);
        debugPrint(
          '[FaceProvider] ❌ No match (best: ${result.confidenceLabel})',
        );
      }
    } catch (e) {
      debugPrint('[FaceProvider] _captureAndProcess error: $e');
      _setStatus(FaceRecognitionStatus.scanning);
    } finally {
      // Temp file cleanup
      if (capturedPath != null) {
        try {
          await File(capturedPath).delete();
        } catch (_) {}
      }
      _isProcessing = false;
    }
  }

  // ── Announce with cooldown ────────────────────────────────────────────────
  Future<void> _maybeAnnounce(FaceMatchResult result) async {
    final now = DateTime.now();
    final cooldown = Duration(
      seconds: FaceRecognitionConfig.announcementCooldownSeconds,
    );

    final isSamePerson = _lastAnnouncedUserId == result.userId;
    final withinCooldown =
        _lastAnnouncementTime != null &&
        now.difference(_lastAnnouncementTime!) < cooldown;

    // ← Yeh check sahi hai — agar problem hai to debug print add karo
    debugPrint(
      '[FaceProvider] Cooldown check — isSame: $isSamePerson,'
      ' withinCooldown: $withinCooldown,'
      ' lastTime: $_lastAnnouncementTime',
    );

    if (isSamePerson && withinCooldown) {
      final remaining = cooldown - now.difference(_lastAnnouncementTime!);
      debugPrint(
        '[FaceProvider] 🔇 Cooldown active — ${remaining.inSeconds}s left',
      );
      return; // ← Yahan return ho raha hai ya nahi?
    }

    _lastAnnouncedUserId = result.userId;
    _lastAnnouncementTime = now;
    debugPrint('[FaceProvider] 🔊 Announcing: ${result.userName}');
    await _ttsService.announce(result.userName);
  }

  // ── Stop ──────────────────────────────────────────────────────────────────
  void stopRecognition() {
    _captureTimer?.cancel();
    _captureTimer = null;
    _isProcessing = false;
    _lastResult = null;
    _totalScans = 0;
    _totalMatches = 0;
    _setStatus(FaceRecognitionStatus.idle);

    debugPrint('[FaceProvider] 🛑 Face recognition stopped');
  }

  void _setStatus(FaceRecognitionStatus status) {
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    stopRecognition();
    _cameraController?.dispose();
    _ttsService.dispose();
    super.dispose();
  }
}
