import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecordModel {
  final String id;
  final String patientId;
  final String caregiverId;
  final int heartRate;
  final int systolic;
  final int diastolic;
  final double temperature;
  final int oxygenLevel;
  final double weight;
  final String? notes;
  final DateTime recordedAt;

  const HealthRecordModel({
    required this.id,
    required this.patientId,
    required this.caregiverId,
    required this.heartRate,
    required this.systolic,
    required this.diastolic,
    required this.temperature,
    required this.oxygenLevel,
    required this.weight,
    this.notes,
    required this.recordedAt,
  });

  factory HealthRecordModel.fromMap(Map<String, dynamic> map, String id) {
    return HealthRecordModel(
      id: id,
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      heartRate: map['heartRate'] ?? 0,
      systolic: map['systolic'] ?? 0,
      diastolic: map['diastolic'] ?? 0,
      temperature: (map['temperature'] ?? 0).toDouble(),
      oxygenLevel: map['oxygenLevel'] ?? 0,
      weight: (map['weight'] ?? 0).toDouble(),
      notes: map['notes'],
      recordedAt: map['recordedAt'] != null
          ? (map['recordedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'patientId': patientId,
        'caregiverId': caregiverId,
        'heartRate': heartRate,
        'systolic': systolic,
        'diastolic': diastolic,
        'temperature': temperature,
        'oxygenLevel': oxygenLevel,
        'weight': weight,
        'notes': notes,
        'recordedAt': FieldValue.serverTimestamp(),
      };

  String get bloodPressure => '$systolic/$diastolic';

  bool get isHeartRateNormal => heartRate >= 60 && heartRate <= 100;
  bool get isOxygenNormal => oxygenLevel >= 95;
  bool get isTempNormal => temperature >= 36.1 && temperature <= 37.2;
  bool get isBpNormal => systolic < 130 && diastolic < 80;
}