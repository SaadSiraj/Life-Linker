import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/notifications.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/model/safe_zone.dart';
import 'package:lifelinker/repository/profile_repo.dart';

class ProfileProvider extends ChangeNotifier {
  final TextEditingController caregiverNameController = TextEditingController();
  final TextEditingController caregiverPhoneController =
      TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientConditionController =
      TextEditingController();
  final TextEditingController emergencyController = TextEditingController();

  UserModel? _profile;
  bool _isLoading = false;
  bool _hasError = false;

  SafeZoneModel _safeZone = const SafeZoneModel(
    enabled: true,
    radiusMeters: 200,
    centerLabel: 'Home – 12 Maplewood Drive',
  );

  NotificationModel _notifications = const NotificationModel(
    sosAlerts: true,
    geofenceBreaches: true,
    medicationReminders: true,
    dailyHealthSummary: false,
    lowBattery: true,
  );

  UserModel? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  SafeZoneModel get safeZone => _safeZone;
  NotificationModel get notifications => _notifications;

  ProfileProvider() {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final result = await ProfileApiService.fetchProfile();
      _profile = result;
      _loadEditControllers();
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void _loadEditControllers() {
    if (_profile == null) return;
    caregiverNameController.text = _profile!.caregiverName;
    caregiverPhoneController.text = _profile!.caregiverPhone;
    patientNameController.text = _profile!.patientName;
    patientConditionController.text = _profile!.patientCondition;
    emergencyController.text = _profile!.patientEmergencyContact;
  }

  Future<void> saveProfile(BuildContext context) async {
    final updated = _profile!.copyWith(
      caregiverName: caregiverNameController.text.trim(),
      caregiverPhone: caregiverPhoneController.text.trim(),
      patientName: patientNameController.text.trim(),
      patientCondition: patientConditionController.text.trim(),
      patientEmergencyContact: emergencyController.text.trim(),
    );
    await ProfileApiService.updateProfile(updated);
    _profile = updated;
    notifyListeners();
    showCustomSnackbar(context, false, 'Profile updated successfully');
  }

  void setSafeZoneEnabled(bool enabled) {
    _safeZone = _safeZone.copyWith(enabled: enabled);
    notifyListeners();
    ProfileApiService.updateSafeZone(_safeZone);
  }

  void setSafeZoneRadius(double radius) {
    _safeZone = _safeZone.copyWith(radiusMeters: radius);
    notifyListeners();
  }

  void commitSafeZoneRadius() {
    ProfileApiService.updateSafeZone(_safeZone);
  }

  void updateNotifications(NotificationModel ns) {
    _notifications = ns;
    notifyListeners();
    ProfileApiService.updateNotifications(ns);
  }

  void signOut(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  void refresh() => fetchProfile();

  @override
  void dispose() {
    caregiverNameController.dispose();
    caregiverPhoneController.dispose();
    patientNameController.dispose();
    patientConditionController.dispose();
    emergencyController.dispose();
    super.dispose();
  }
}
