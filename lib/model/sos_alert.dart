import 'package:cloud_firestore/cloud_firestore.dart';

enum SosAlertType { caregiverToPatient, patientToCaregiver }

class SosAlertModel {
  final String id;
  final SosAlertType type;
  final bool isAcknowledged;
  final DateTime createdAt;
  final String patientId;
  final String caregiverId;

  const SosAlertModel({
    required this.id,
    required this.type,
    required this.isAcknowledged,
    required this.createdAt,
    required this.patientId,
    required this.caregiverId,
  });

  factory SosAlertModel.fromMap(Map<String, dynamic> map, String id) {
    return SosAlertModel(
      id: id,
      type: map['type'] == 'caregiverToPatient'
          ? SosAlertType.caregiverToPatient
          : SosAlertType.patientToCaregiver,
      isAcknowledged: map['isAcknowledged'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type == SosAlertType.caregiverToPatient
          ? 'caregiverToPatient'
          : 'patientToCaregiver',
      'isAcknowledged': isAcknowledged,
      'createdAt': FieldValue.serverTimestamp(),
      'patientId': patientId,
      'caregiverId': caregiverId,
    };
  }
}
