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

  
  static const Color primaryGreyColor = Color(0xFF282729);
  static const Color green = Color(0xFF0FCC72);
  static const Color greenDark = Color(0xFF0AAB5F);

  static const Color bgColor = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;

  static const Color black900 = Color(0xFF000000);
  static const Color black800 = Color(0xFF1A1A1A);
  static const Color black700 = Color(0xFF2E2E2E);
  static const Color black600 = Color(0xFF4A4A4A);
  static const Color black500 = Color(0xFF666666);

  static const Color grey100 = Color(0xFFF1F3F5);
  static const Color grey200 = Color(0xFFE2E6EA);
  static const Color grey300 = Color(0xFFD1D7DE);
  static const Color grey400 = Color(0xFFB0BAC5);
  static const Color grey500 = Color(0xFF8E9AA9);
  static const Color grey600 = Color(0xFF6B7F94);
  static const Color grey700 = Color(0xFF4F6375);
  static const Color grey800 = Color(0xFF354A5F);
  static const Color grey900 = Color(0xFF1F2D3A);

  static const Color warning = Color(0xFFF6B455);
  static const Color danger = Color(0xFFFF3919);
  static const Color info = Color(0xFF3C7DFF);

  static const Color blackButton = Color(0xFF111111);
  static const Color surfaceGrey = Color(0xFFF0F0F0);
  static const Color transparent = Colors.transparent;

  static Color textFieldFilledClr = Colors.grey.shade800.withValues(alpha: .3);
  static Color unFocusGreyClr = Colors.black12;


}