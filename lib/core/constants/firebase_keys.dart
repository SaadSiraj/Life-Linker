abstract final class FirebaseKeys {
  // Collections
  static const String sosAlerts = 'sos_alerts';
  static const String voiceMessages = 'voice_messages';
  static const String webrtcSessions = 'webrtc_sessions';
  static const String users = 'users';

  // SOS fields
  static const String senderId = 'senderId';
  static const String receiverId = 'receiverId';
  static const String type = 'type';
  static const String timestamp = 'timestamp';
  static const String isRead = 'isRead';

  // Voice fields
  static const String audioUrl = 'audioUrl';
  static const String isPlayed = 'isPlayed';
  static const String duration = 'duration';

  // WebRTC fields
  static const String caregiverId = 'caregiverId';
  static const String patientId = 'patientId';
  static const String offer = 'offer';
  static const String answer = 'answer';
  static const String iceCandidates = 'iceCandidates';
  static const String status = 'status';
  static const String createdAt = 'createdAt';

  // SOS types
  static const String sosTypeFromCaregiver = 'caregiver_to_patient';
  static const String sosTypeFromPatient = 'patient_to_caregiver';

  // WebRTC status
  static const String statusWaiting = 'waiting';
  static const String statusActive = 'active';
  static const String statusEnded = 'ended';

  // FCM topic prefix
  static const String fcmUserPrefix = 'user_';
}
