import 'package:cloud_firestore/cloud_firestore.dart';

class CameraSessionModel {
  final String patientId;
  final bool isActive;
  final DateTime updatedAt;

  const CameraSessionModel({
    required this.patientId,
    required this.isActive,
    required this.updatedAt,
  });

  factory CameraSessionModel.fromMap(Map<String, dynamic> map) {
    return CameraSessionModel(
      patientId: map['patientId'] ?? '',
      isActive: map['isActive'] ?? false,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
