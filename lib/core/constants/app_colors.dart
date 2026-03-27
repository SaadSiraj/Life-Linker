import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2A7FFF);

  // Success
  static const Color success = Color(0xFF34C759);

  // Alert / Error
  static const Color alert = Color(0xFFFF3B30);

  // Background
  static const Color background = Color(0xFFF5F7FA);

  // Text
  static const Color textDark = Color(0xFF1C1C1E);

  // Card
  static const Color cardWhite = Color(0xFFFFFFFF);

  // Extra (from UI)
  static const Color border = Color(0xFFE5E7EB);
  static const Color iconGrey = Color(0xFF8E8E93);
  static const Color divider = Color(0xFFEDEDED);

  // Status Colors (used in medication UI)
  static const Color pending = Color(0xFFFF9500);
  static const Color taken = success;
  static const Color missed = alert;

  // Transparent overlays
  static const Color shadow = Color(0x1A000000);
}