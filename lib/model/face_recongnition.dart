class FaceRecognitionResult {
  final bool faceDetected;
  final bool matched;
  final String? matchedPersonId;
  final double? confidence;
  final String? errorMessage;

  const FaceRecognitionResult({
    required this.faceDetected,
    this.matched = false,
    this.matchedPersonId,
    this.confidence,
    this.errorMessage,
  });
}