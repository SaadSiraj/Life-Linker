import 'package:cloud_firestore/cloud_firestore.dart';

enum WebRtcSessionStatus { waiting, active, ended }

class WebRtcSessionModel {
  final String sessionId;
  final String patientId;
  final String caregiverId;
  final Map<String, dynamic>? offer;
  final Map<String, dynamic>? answer;
  final WebRtcSessionStatus status;
  final DateTime createdAt;

  const WebRtcSessionModel({
    required this.sessionId,
    required this.patientId,
    required this.caregiverId,
    this.offer,
    this.answer,
    required this.status,
    required this.createdAt,
  });

  factory WebRtcSessionModel.fromMap(Map<String, dynamic> map, String id) {
    return WebRtcSessionModel(
      sessionId: id,
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      offer: map['offer'] as Map<String, dynamic>?,
      answer: map['answer'] as Map<String, dynamic>?,
      status: _parseStatus(map['status']),
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'caregiverId': caregiverId,
      'offer': offer,
      'answer': answer,
      'status': _statusString(status),
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  WebRtcSessionModel copyWith({
    Map<String, dynamic>? offer,
    Map<String, dynamic>? answer,
    WebRtcSessionStatus? status,
  }) {
    return WebRtcSessionModel(
      sessionId: sessionId,
      patientId: patientId,
      caregiverId: caregiverId,
      offer: offer ?? this.offer,
      answer: answer ?? this.answer,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }

  static WebRtcSessionStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return WebRtcSessionStatus.active;
      case 'ended':
        return WebRtcSessionStatus.ended;
      default:
        return WebRtcSessionStatus.waiting;
    }
  }

  static String _statusString(WebRtcSessionStatus status) {
    switch (status) {
      case WebRtcSessionStatus.active:
        return 'active';
      case WebRtcSessionStatus.ended:
        return 'ended';
      case WebRtcSessionStatus.waiting:
        return 'waiting';
    }
  }

  bool get isWaiting => status == WebRtcSessionStatus.waiting;
  bool get isActive => status == WebRtcSessionStatus.active;
  bool get isEnded => status == WebRtcSessionStatus.ended;
}
