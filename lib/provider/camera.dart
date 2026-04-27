import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:lifelinker/repository/camera_frame_repo.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class CameraProvider extends ChangeNotifier {
  CameraController? _cameraController;
  StreamSubscription<Map<String, dynamic>?>? _frameSubscription;

  bool _isCameraActive = false;
  bool _isInitializing = false;
  Uint8List? _currentFrame;
  String? _errorMessage;
  bool _isStreaming = false;

  bool get isCameraActive => _isCameraActive;
  bool get isInitializing => _isInitializing;
  Uint8List? get currentFrame => _currentFrame;
  String? get errorMessage => _errorMessage;

  DateTime _lastFramePush = DateTime(2000);

  // ── Patient side ──────────────────────────────────────────────────────────

  Future<void> startCamera(String patientId) async {
    debugPrint('[CameraProvider] startCamera() called — patientId: $patientId');

    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Get available cameras
      final cameras = await availableCameras();
      debugPrint('[CameraProvider] availableCameras count: ${cameras.length}');

      if (cameras.isEmpty) {
        debugPrint('[CameraProvider] ERROR: No cameras found');
        _errorMessage = 'No camera found on this device';
        _isInitializing = false;
        notifyListeners();
        return;
      }

      for (var i = 0; i < cameras.length; i++) {
        debugPrint(
          '[CameraProvider] Camera[$i]: '
          'name=${cameras[i].name}, '
          'direction=${cameras[i].lensDirection}',
        );
      }

      // Step 2: Pick back camera
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      debugPrint(
        '[CameraProvider] Selected camera: ${camera.name} — ${camera.lensDirection}',
      );

      // Step 3: Create controller
      _cameraController = CameraController(
        camera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      // Step 4: Initialize
      debugPrint('[CameraProvider] Initializing CameraController...');
      await _cameraController!.initialize();
      debugPrint('[CameraProvider] CameraController initialized successfully');

      _isCameraActive = true;
      _isInitializing = false;
      _isStreaming = true;
      notifyListeners();

      // Step 5: Start frame stream
      debugPrint('[CameraProvider] Starting image stream...');
      _startFrameStreaming(patientId);
    } on CameraException catch (e) {
      debugPrint(
        '[CameraProvider] CameraException: code=${e.code}, desc=${e.description}',
      );
      _errorMessage = 'Camera error: ${e.description}';
      _isInitializing = false;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('[CameraProvider] Unexpected error: $e');
      debugPrint('[CameraProvider] Stack: $stack');
      _errorMessage = 'Camera error: $e';
      _isInitializing = false;
      notifyListeners();
    }
  }

  void _startFrameStreaming(String patientId) {
    if (_cameraController == null) {
      debugPrint('[CameraProvider] _startFrameStreaming: controller is null');
      return;
    }

    debugPrint('[CameraProvider] _startFrameStreaming started');
    int frameCount = 0;
    int skippedFrames = 0;

    _cameraController!.startImageStream((CameraImage image) async {
      if (!_isStreaming) return;

      frameCount++;
      if (frameCount % 30 == 0) {
        debugPrint(
          '[CameraProvider] Frames received: $frameCount, '
          'skipped: $skippedFrames, '
          'format: ${image.format.group}, '
          'size: ${image.width}x${image.height}',
        );
      }

      // Throttle: max 1 frame per second to Firebase
      final now = DateTime.now();
      if (now.difference(_lastFramePush).inMilliseconds < 1000) {
        skippedFrames++;
        return;
      }
      _lastFramePush = now;

      try {
        debugPrint(
          '[CameraProvider] Processing frame — '
          'planes: ${image.planes.length}, '
          'format: ${image.format.group}',
        );

        final bytes = await _convertCameraImageToBytes(image);

        if (bytes == null) {
          debugPrint(
            '[CameraProvider] _convertCameraImageToBytes returned null',
          );
          return;
        }

        debugPrint(
          '[CameraProvider] Frame converted successfully — size: ${bytes.length} bytes',
        );

        _currentFrame = bytes;
        notifyListeners();

        final base64Frame = base64Encode(bytes);
        await CameraFrameRepository.pushFrame(
          patientId: patientId,
          base64Frame: base64Frame,
        );
        debugPrint('[CameraProvider] Frame pushed to Firebase successfully');
      } catch (e, stack) {
        debugPrint('[CameraProvider] Frame processing error: $e');
        debugPrint('[CameraProvider] Stack: $stack');
      }
    });
  }

  Future<Uint8List?> _convertCameraImageToBytes(CameraImage image) async {
    try {
      debugPrint(
        '[CameraProvider] Converting image — '
        'format: ${image.format.group}, '
        'planes: ${image.planes.length}',
      );

      // JPEG format — use directly, no opencv needed
      if (image.format.group == ImageFormatGroup.jpeg) {
        debugPrint('[CameraProvider] Already JPEG — using directly');
        final bytes = image.planes[0].bytes;
        debugPrint('[CameraProvider] JPEG size: ${bytes.length}');
        return bytes;
      }

      // YUV420 — convert manually via opencv cvtColor
      if (image.format.group == ImageFormatGroup.yuv420 ||
          image.format.group == ImageFormatGroup.nv21) {
        return await _yuvToJpeg(image);
      }

      // BGRA8888 (iOS) — convert via opencv
      if (image.format.group == ImageFormatGroup.bgra8888) {
        return await _bgraToJpeg(image);
      }

      debugPrint('[CameraProvider] Unknown format: ${image.format.group}');
      return null;
    } catch (e, stack) {
      debugPrint('[CameraProvider] _convertCameraImageToBytes error: $e');
      debugPrint('[CameraProvider] Stack: $stack');
      return null;
    }
  }

  // iOS BGRA8888 support
  Future<Uint8List?> _bgraToJpeg(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;
      final bytes = image.planes[0].bytes;

      debugPrint(
        '[CameraProvider] _bgraToJpeg — ${width}x$height, bytes: ${bytes.length}',
      );

      final mat = cv.Mat.fromList(height, width, cv.MatType.CV_8UC4, bytes);

      if (mat.isEmpty) {
        mat.dispose();
        return null;
      }

      final bgrMat = cv.Mat.empty();
      cv.cvtColor(mat, cv.COLOR_BGRA2BGR, dst: bgrMat);
      mat.dispose();

      final params = cv.VecI32.fromList([cv.IMWRITE_JPEG_QUALITY, 40]);
      final (success, encoded) = cv.imencode('.jpg', bgrMat, params: params);

      bgrMat.dispose();
      params.dispose();

      return success && encoded.isNotEmpty ? encoded : null;
    } catch (e) {
      debugPrint('[CameraProvider] _bgraToJpeg error: $e');
      return null;
    }
  }

  Future<Uint8List?> _yuvToJpeg(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;

      debugPrint('[CameraProvider] _yuvToJpeg — ${width}x$height');

      final yPlane = image.planes[0];
      final uPlane = image.planes[1];
      final vPlane = image.planes[2];

      final int yRowStride = yPlane.bytesPerRow;
      final int uRowStride = uPlane.bytesPerRow;
      final int vRowStride = vPlane.bytesPerRow;

      final int yPixelStride = yPlane.bytesPerPixel ?? 1;
      final int uPixelStride = uPlane.bytesPerPixel ?? 1;
      final int vPixelStride = vPlane.bytesPerPixel ?? 1;

      final int ySize = width * height;
      final int uvSize = (width ~/ 2) * (height ~/ 2);
      final i420Bytes = Uint8List(ySize + uvSize + uvSize);

      // Copy Y plane
      int destOffset = 0;
      for (int row = 0; row < height; row++) {
        final int rowStart = row * yRowStride;
        for (int col = 0; col < width; col++) {
          i420Bytes[destOffset++] = yPlane.bytes[rowStart + col * yPixelStride];
        }
      }
      debugPrint('[CameraProvider] Y plane copied — destOffset: $destOffset');

      // Copy U plane
      final int uvHeight = height ~/ 2;
      final int uvWidth = width ~/ 2;
      for (int row = 0; row < uvHeight; row++) {
        final int rowStart = row * uRowStride;
        for (int col = 0; col < uvWidth; col++) {
          i420Bytes[destOffset++] = uPlane.bytes[rowStart + col * uPixelStride];
        }
      }
      debugPrint('[CameraProvider] U plane copied — destOffset: $destOffset');

      // Copy V plane
      for (int row = 0; row < uvHeight; row++) {
        final int rowStart = row * vRowStride;
        for (int col = 0; col < uvWidth; col++) {
          i420Bytes[destOffset++] = vPlane.bytes[rowStart + col * vPixelStride];
        }
      }
      debugPrint('[CameraProvider] All planes copied — total: $destOffset');

      // Create Mat from I420 bytes
      final yuvMat = cv.Mat.fromList(
        height + height ~/ 2,
        width,
        cv.MatType.CV_8UC1,
        i420Bytes,
      );

      debugPrint(
        '[CameraProvider] yuvMat — rows: ${yuvMat.rows}, cols: ${yuvMat.cols}, empty: ${yuvMat.isEmpty}',
      );

      if (yuvMat.isEmpty) {
        yuvMat.dispose();
        return null;
      }

      // Convert YUV I420 → BGR
      final bgrMat = cv.Mat.empty();
      cv.cvtColor(yuvMat, cv.COLOR_YUV2BGR_I420, dst: bgrMat);
      yuvMat.dispose();

      debugPrint(
        '[CameraProvider] bgrMat — rows: ${bgrMat.rows}, cols: ${bgrMat.cols}, empty: ${bgrMat.isEmpty}',
      );

      if (bgrMat.isEmpty) {
        bgrMat.dispose();
        return null;
      }

      // Encode to JPEG
      final params = cv.VecI32.fromList([cv.IMWRITE_JPEG_QUALITY, 40]);
      final (success, encoded) = cv.imencode('.jpg', bgrMat, params: params);

      bgrMat.dispose();
      params.dispose();

      debugPrint(
        '[CameraProvider] imencode — success: $success, size: ${encoded.length}',
      );

      return success && encoded.isNotEmpty ? encoded : null;
    } catch (e, stack) {
      debugPrint('[CameraProvider] _yuvToJpeg error: $e');
      debugPrint('[CameraProvider] Stack: $stack');
      return null;
    }
  }

  Future<void> stopCamera(String patientId) async {
    debugPrint('[CameraProvider] stopCamera() called');
    _isStreaming = false;
    try {
      await _cameraController?.stopImageStream();
    } catch (e) {
      debugPrint('[CameraProvider] stopImageStream error: $e');
    }
    try {
      await _cameraController?.dispose();
    } catch (e) {
      debugPrint('[CameraProvider] controller dispose error: $e');
    }
    _cameraController = null;
    _isCameraActive = false;
    _currentFrame = null;

    await CameraFrameRepository.setInactive(patientId);
    notifyListeners();
    debugPrint('[CameraProvider] stopCamera() complete');
  }

  // ── Caregiver side ────────────────────────────────────────────────────────

  void listenToPatientSession(String patientId) {
    debugPrint(
      '[CameraProvider] listenToPatientSession — patientId: $patientId',
    );
    _frameSubscription?.cancel();
    _frameSubscription = CameraFrameRepository.listenToFrame(patientId).listen(
      (data) {
        if (data == null) {
          debugPrint('[CameraProvider] Firebase frame data is null');
          _isCameraActive = false;
          _currentFrame = null;
          notifyListeners();
          return;
        }

        final isActive = data['isActive'] as bool? ?? false;
        final frameBase64 = data['frame'] as String?;

        debugPrint(
          '[CameraProvider] Firebase frame received — '
          'isActive: $isActive, '
          'hasFrame: ${frameBase64 != null && frameBase64.isNotEmpty}',
        );

        _isCameraActive = isActive;

        if (isActive && frameBase64 != null && frameBase64.isNotEmpty) {
          try {
            _currentFrame = base64Decode(frameBase64);
            debugPrint(
              '[CameraProvider] Frame decoded — size: ${_currentFrame!.length} bytes',
            );
          } catch (e) {
            debugPrint('[CameraProvider] base64Decode error: $e');
            _currentFrame = null;
          }
        } else {
          _currentFrame = null;
        }

        notifyListeners();
      },
      onError: (e) {
        debugPrint('[CameraProvider] Firebase stream error: $e');
      },
    );
  }

  void stopSessionListener() {
    debugPrint('[CameraProvider] stopSessionListener() called');
    _frameSubscription?.cancel();
    _frameSubscription = null;
    _isCameraActive = false;
    _currentFrame = null;
    notifyListeners();
  }

  @override
  void dispose() {
    debugPrint('[CameraProvider] dispose() called');
    _isStreaming = false;
    _cameraController?.dispose();
    _frameSubscription?.cancel();
    super.dispose();
  }
}
