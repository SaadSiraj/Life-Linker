import 'package:cloud_firestore/cloud_firestore.dart';

enum MedicationFrequency { daily, weekly, asNeeded }

enum MedicationStatus { pending, taken, missed, skipped }

class MedicationScheduleModel {
  final String id;
  final String patientId;
  final String caregiverId;
  final String name;
  final String dosage;
  final MedicationFrequency frequency;
  final List<String> times;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;

  const MedicationScheduleModel({
    required this.id,
    required this.patientId,
    required this.caregiverId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    this.notes,
    required this.isActive,
    required this.createdAt,
  });

  factory MedicationScheduleModel.fromMap(Map<String, dynamic> map, String id) {
    return MedicationScheduleModel(
      id: id,
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: _parseFrequency(map['frequency']),
      times: List<String>.from(map['times'] ?? []),
      notes: map['notes'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'caregiverId': caregiverId,
      'name': name,
      'dosage': dosage,
      'frequency': _frequencyString(frequency),
      'times': times,
      'notes': notes,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  MedicationScheduleModel copyWith({
    String? name,
    String? dosage,
    MedicationFrequency? frequency,
    List<String>? times,
    String? notes,
    bool? isActive,
  }) {
    return MedicationScheduleModel(
      id: id,
      patientId: patientId,
      caregiverId: caregiverId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  static MedicationFrequency _parseFrequency(String? value) {
    switch (value) {
      case 'weekly':
        return MedicationFrequency.weekly;
      case 'asNeeded':
        return MedicationFrequency.asNeeded;
      default:
        return MedicationFrequency.daily;
    }
  }

  static String _frequencyString(MedicationFrequency freq) {
    switch (freq) {
      case MedicationFrequency.weekly:
        return 'weekly';
      case MedicationFrequency.asNeeded:
        return 'asNeeded';
      case MedicationFrequency.daily:
        return 'daily';
    }
  }

  String get frequencyLabel {
    switch (frequency) {
      case MedicationFrequency.daily:
        return 'Daily';
      case MedicationFrequency.weekly:
        return 'Weekly';
      case MedicationFrequency.asNeeded:
        return 'As Needed';
    }
  }
}