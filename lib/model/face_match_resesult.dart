import 'package:lifelinker/core/config/face_recognition_config.dart';

enum FaceRecognitionStatus {
  idle,
  scanning,
  detected,
  matched,
  noMatch,
  noFace, 
  error,
}

class FaceMatchResult {
  final String userId;
  final String userName;
  final double confidence;
  final bool noFaceDetected; 

  const FaceMatchResult({
    required this.userId,
    required this.userName,
    required this.confidence,
    this.noFaceDetected = false, 
  });

  bool get isMatch =>
      !noFaceDetected && confidence >= FaceRecognitionConfig.matchThreshold;

  String get confidenceLabel => '${confidence.toStringAsFixed(1)}%';

  factory FaceMatchResult.noMatch() {
    return const FaceMatchResult(
      userId: '',
      userName: 'Unknown',
      confidence: 0.0,
    );
  }

  factory FaceMatchResult.noFaceInFrame() {
    return const FaceMatchResult(
      userId: '',
      userName: 'No Face',
      confidence: 0.0,
      noFaceDetected: true,
    );
  }
}
