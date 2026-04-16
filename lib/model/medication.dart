import 'package:flutter/material.dart';

enum MedStatus { none, pending, taken, missed }

class MedicationModel {
  final String name;
  final String time;
  final Color color;
  final IconData icon;
  final MedStatus status;

  const MedicationModel({
    required this.name,
    required this.time,
    required this.color,
    required this.icon,
    required this.status,
  });
}
