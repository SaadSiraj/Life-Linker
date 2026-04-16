import 'package:flutter/material.dart';
import 'package:lifelinker/model/medication.dart';

class ScheduledMedicationModel {
  final String name;
  final String time;
  final Color color;
  final IconData icon;
  final MedStatus status;

  const ScheduledMedicationModel({
    required this.name,
    required this.time,
    required this.color,
    required this.icon,
    required this.status,
  });
}

