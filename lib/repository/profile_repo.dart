// ─── Mock API Service ──────────────────────────────────────────────────────

import 'package:lifelinker/model/notifications.dart';
import 'package:lifelinker/model/safe_zone.dart';
import 'package:lifelinker/model/user.dart';

class ProfileApiService {
  static Future<UserModel> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const UserModel(
      caregiverName: 'Sarah Adeola',
      caregiverEmail: 'sarah@example.com',
      caregiverPhone: '+234 801 234 5678',
      patientName: 'John Adeola',
      patientAge: 72,
      patientCondition: "Alzheimer's Disease",
      patientBloodGroup: 'O+',
      patientEmergencyContact: '+234 802 987 6543',
    );
  }

  static Future<void> updateProfile(UserModel profile) async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  static Future<void> updateSafeZone(SafeZoneModel settings) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  static Future<void> updateNotifications(NotificationModel s) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
