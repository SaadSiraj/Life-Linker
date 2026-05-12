import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/medication_scheduled.dart';

class MedicationLogModel {
  final String id;
  final String medicationId;
  final String patientId;
  final String medicationName;
  final String dosage;
  final String scheduledTime;
  final MedicationStatus status;
  final DateTime scheduledDate;
  final DateTime? takenAt;
  final String? note;

  const MedicationLogModel({
    required this.id,
    required this.medicationId,
    required this.patientId,
    required this.medicationName,
    required this.dosage,
    required this.scheduledTime,
    required this.status,
    required this.scheduledDate,
    this.takenAt,
    this.note,
  });

  factory MedicationLogModel.fromMap(Map<String, dynamic> map, String id) {
    return MedicationLogModel(
      id: id,
      medicationId: map['medicationId'] ?? '',
      patientId: map['patientId'] ?? '',
      medicationName: map['medicationName'] ?? '',
      dosage: map['dosage'] ?? '',
      scheduledTime: map['scheduledTime'] ?? '',
      status: _parseStatus(map['status']),
      scheduledDate: map['scheduledDate'] != null
          ? (map['scheduledDate'] as Timestamp).toDate()
          : DateTime.now(),
      takenAt: map['takenAt'] != null
          ? (map['takenAt'] as Timestamp).toDate()
          : null,
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'medicationId': medicationId,
      'patientId': patientId,
      'medicationName': medicationName,
      'dosage': dosage,
      'scheduledTime': scheduledTime,
      'status': _statusString(status),
      'scheduledDate': Timestamp.fromDate(scheduledDate),
      'takenAt': takenAt != null ? Timestamp.fromDate(takenAt!) : null,
      'note': note,
    };
  }

  MedicationLogModel copyWith({MedicationStatus? status, DateTime? takenAt, String? note}) {
    return MedicationLogModel(
      id: id,
      medicationId: medicationId,
      patientId: patientId,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      status: status ?? this.status,
      scheduledDate: scheduledDate,
      takenAt: takenAt ?? this.takenAt,
      note: note ?? this.note,
    );
  }

  static MedicationStatus _parseStatus(String? value) {
    switch (value) {
      case 'taken':
        return MedicationStatus.taken;
      case 'missed':
        return MedicationStatus.missed;
      case 'skipped':
        return MedicationStatus.skipped;
      default:
        return MedicationStatus.pending;
    }
  }

  static String _statusString(MedicationStatus status) {
    switch (status) {
      case MedicationStatus.taken:
        return 'taken';
      case MedicationStatus.missed:
        return 'missed';
      case MedicationStatus.skipped:
        return 'skipped';
      case MedicationStatus.pending:
        return 'pending';
    }
  }

  bool get isTaken => status == MedicationStatus.taken;
  bool get isMissed => status == MedicationStatus.missed;
  bool get isPending => status == MedicationStatus.pending;
}