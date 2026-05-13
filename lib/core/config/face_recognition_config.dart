abstract final class FaceRecognitionConfig {
  FaceRecognitionConfig._();

  static const String apiKey = 'OZGYd09Gz-F_RWMIxE4FY1tZedmxGIcx';
  static const String apiSecret = 'NJrtA60SNpDpGiQ7-AwBvscKNNFZc5cd';
  static const String compareEndpoint =
      'https://api-us.faceplusplus.com/facepp/v3/compare';

  // ── Matching Config ───────────────────────────────────────────────────────
  // 60% se upar = match considered
  static const double matchThreshold = 60.0;

  // Har kitne seconds baad frame capture ho
  static const int captureIntervalSeconds = 6;

  // Same person announce karne ka cooldown
  static const int announcementCooldownSeconds = 20;

  // Max kitne users fetch karo
  static const int maxUsersToFetch = 100;
}
