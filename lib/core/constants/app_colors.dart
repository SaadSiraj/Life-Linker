import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2A7FFF);
  static const Color primaryLight = Color(0xFF4DA3FF);
  static const Color primaryDark = Color(0xFF1A5FCC);

  static const Color medicationViolet = Color(0xFF7B61FF);
  static const Color sleepRem = Color(0xFF90C4FF);

  static const Color success = Color(0xFF34C759);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color successText = Color(0xFF059669);
  static const Color successDark = Color(0xFF10B981);

  static const Color alert = Color(0xFFFF3B30);
  static const Color alertLight = Color(0xFFFEF2F2);

  static const Color pending = Color(0xFFFF9500);
  static const Color pendingLight = Color(0xFFFFFBEB);

  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundAlt = Color(0xFFF5F7FB);
  static const Color surface = Colors.white;

  static const Color textDark = Color(0xFF1C1C1E);
  static const Color textMedium = Color(0xFF4A4A4A);

  static const Color iconGrey = Color(0xFF8E8E93);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFEDEDED);
  static const Color dividerLight = Color(0xFFF1F5F9);

  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowStrong = Color(0x0D000000);

  static const Color cardWhite = Colors.white;

  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFF5F3FF);

  static const Color blue = Color(0xFF3B82F6);
  static const Color blueLight = Color(0xFFEFF6FF);
  static const Color blueLighter = Color(0xFFBFDBFE);

  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFFFBEB);

  static const Color orange = Color(0xFFF97316);

  static const Color grey100 = Color(0xFFF1F3F5);
  static const Color grey200 = Color(0xFFE2E6EA);
  static const Color grey400 = Color(0xFFB0BAC5);
  static const Color grey500 = Color(0xFF8E9AA9);

  static const Color black900 = Color(0xFF000000);
  static const Color black800 = Color(0xFF1A1A1A);

  static const Color danger = Color(0xFFFF3919);
  static const Color info = Color(0xFF3C7DFF);
  static const Color transparent = Colors.transparent;

  static const Color mapGrid = Color(0xFFD0DFF5);
  static const Color mapBackground = Color(0xFFE8F0FB);

  static Color get unFocusGreyClr => Colors.black12;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primary, primaryDark],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient appBarGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
