import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/profile.dart';

class ProfileProvider extends ChangeNotifier {
  final TextEditingController caregiverNameController = TextEditingController();
  final TextEditingController caregiverPhoneController =
      TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientConditionController =
      TextEditingController();
  final TextEditingController emergencyController = TextEditingController();

  UserProfileModel? _profile;
  bool _isLoading = false;
  bool _hasError = false;

  SafeZoneModel _safeZone = const SafeZoneModel(
    enabled: true,
    radiusMeters: 200,
    centerLabel: 'Home – 12 Maplewood Drive',
  );

  NotificationSettingsModel _notifications = const NotificationSettingsModel(
    sosAlerts: true,
    geofenceBreaches: true,
    medicationReminders: true,
    dailyHealthSummary: false,
    lowBattery: true,
  );

  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  SafeZoneModel get safeZone => _safeZone;
  NotificationSettingsModel get notifications => _notifications;

  ProfileProvider() {
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 600));
      _profile = const UserProfileModel(
        caregiverName: 'Sarah Adeola',
        caregiverEmail: 'sarah@example.com',
        caregiverPhone: '+234 801 234 5678',
        patientName: 'John Adeola',
        patientAge: 72,
        patientCondition: "Alzheimer's Disease",
        patientBloodGroup: 'O+',
        patientEmergencyContact: '+234 802 987 6543',
      );
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
    await Future.delayed(const Duration(milliseconds: 800));
    _profile = updated;
    notifyListeners();
    showCustomSnackbar(context, false, 'Profile updated successfully');
  }

  void setSafeZoneEnabled(bool enabled) {
    _safeZone = _safeZone.copyWith(enabled: enabled);
    notifyListeners();
  }

  void setSafeZoneRadius(double radius) {
    _safeZone = _safeZone.copyWith(radiusMeters: radius);
    notifyListeners();
  }

  void updateNotifications(NotificationSettingsModel ns) {
    _notifications = ns;
    notifyListeners();
  }

  void signOut(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

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
