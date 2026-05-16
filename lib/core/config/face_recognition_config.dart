abstract final class FaceRecognitionConfig {
  FaceRecognitionConfig._();

  static const double matchThreshold = 60.0;
  static const int captureIntervalSeconds = 6;
  static const int announcementCooldownSeconds = 20;
  static const int maxUsersToFetch = 100;
}
