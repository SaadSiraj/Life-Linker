import 'package:cloud_firestore/cloud_firestore.dart';

enum SleepQuality { excellent, good, fair, poor }

class SleepRoutineModel {
  final String id;
  final String patientId;
  final String caregiverId;
  final String title;
  final String bedtime;
  final String wakeTime;
  final int targetHours;
  final List<String> sleepTips;
  final bool isActive;
  final DateTime createdAt;

  const SleepRoutineModel({
    required this.id,
    required this.patientId,
    required this.caregiverId,
    required this.title,
    required this.bedtime,
    required this.wakeTime,
    required this.targetHours,
    required this.sleepTips,
    required this.isActive,
    required this.createdAt,
  });

  factory SleepRoutineModel.fromMap(Map<String, dynamic> map, String id) {
    return SleepRoutineModel(
      id: id,
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
      title: map['title'] ?? '',
      bedtime: map['bedtime'] ?? '',
      wakeTime: map['wakeTime'] ?? '',
      targetHours: map['targetHours'] ?? 8,
      sleepTips: List<String>.from(map['sleepTips'] ?? []),
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'patientId': patientId,
    'caregiverId': caregiverId,
    'title': title,
    'bedtime': bedtime,
    'wakeTime': wakeTime,
    'targetHours': targetHours,
    'sleepTips': sleepTips,
    'isActive': isActive,
    'createdAt': FieldValue.serverTimestamp(),
  };

  SleepRoutineModel copyWith({
    String? title,
    String? bedtime,
    String? wakeTime,
    int? targetHours,
    List<String>? sleepTips,
    bool? isActive,
  }) {
    return SleepRoutineModel(
      id: id,
      patientId: patientId,
      caregiverId: caregiverId,
      title: title ?? this.title,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      targetHours: targetHours ?? this.targetHours,
      sleepTips: sleepTips ?? this.sleepTips,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
