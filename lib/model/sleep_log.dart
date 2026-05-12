import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/sleep_routine.dart';

class SleepLogModel {
  final String id;
  final String patientId;
  final String routineId;
  final DateTime date;
  final String actualBedtime;
  final String actualWakeTime;
  final double actualHours;
  final SleepQuality quality;
  final String? notes;
  final DateTime loggedAt;

  const SleepLogModel({
    required this.id,
    required this.patientId,
    required this.routineId,
    required this.date,
    required this.actualBedtime,
    required this.actualWakeTime,
    required this.actualHours,
    required this.quality,
    this.notes,
    required this.loggedAt,
  });

  factory SleepLogModel.fromMap(Map<String, dynamic> map, String id) {
    return SleepLogModel(
      id: id,
      patientId: map['patientId'] ?? '',
      routineId: map['routineId'] ?? '',
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
      actualBedtime: map['actualBedtime'] ?? '',
      actualWakeTime: map['actualWakeTime'] ?? '',
      actualHours: (map['actualHours'] ?? 0).toDouble(),
      quality: _parseQuality(map['quality']),
      notes: map['notes'],
      loggedAt: map['loggedAt'] != null
          ? (map['loggedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'routineId': routineId,
    'date': Timestamp.fromDate(date),
    'actualBedtime': actualBedtime,
    'actualWakeTime': actualWakeTime,
    'actualHours': actualHours,
    'quality': _qualityString(quality),
    'notes': notes,
    'loggedAt': FieldValue.serverTimestamp(),
  };

  static SleepQuality _parseQuality(String? value) {
    switch (value) {
      case 'excellent':
        return SleepQuality.excellent;
      case 'good':
        return SleepQuality.good;
      case 'fair':
        return SleepQuality.fair;
      default:
        return SleepQuality.poor;
    }
  }

  static String _qualityString(SleepQuality q) {
    switch (q) {
      case SleepQuality.excellent:
        return 'excellent';
      case SleepQuality.good:
        return 'good';
      case SleepQuality.fair:
        return 'fair';
      case SleepQuality.poor:
        return 'poor';
    }
  }

  String get qualityLabel {
    switch (quality) {
      case SleepQuality.excellent:
        return 'Excellent';
      case SleepQuality.good:
        return 'Good';
      case SleepQuality.fair:
        return 'Fair';
      case SleepQuality.poor:
        return 'Poor';
    }
  }

  bool get metTarget => actualHours >= 6.0;
}
