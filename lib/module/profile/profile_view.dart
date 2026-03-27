import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/shared/app_text.dart';

// ─── Models ────────────────────────────────────────────────────────────────

class UserProfile {
  final String caregiverName;
  final String caregiverEmail;
  final String caregiverPhone;
  final String patientName;
  final int patientAge;
  final String patientCondition;
  final String patientBloodGroup;
  final String patientEmergencyContact;

  const UserProfile({
    required this.caregiverName,
    required this.caregiverEmail,
    required this.caregiverPhone,
    required this.patientName,
    required this.patientAge,
    required this.patientCondition,
    required this.patientBloodGroup,
    required this.patientEmergencyContact,
  });

  UserProfile copyWith({
    String? caregiverName,
    String? caregiverEmail,
    String? caregiverPhone,
    String? patientName,
    int? patientAge,
    String? patientCondition,
    String? patientBloodGroup,
    String? patientEmergencyContact,
  }) {
    return UserProfile(
      caregiverName: caregiverName ?? this.caregiverName,
      caregiverEmail: caregiverEmail ?? this.caregiverEmail,
      caregiverPhone: caregiverPhone ?? this.caregiverPhone,
      patientName: patientName ?? this.patientName,
      patientAge: patientAge ?? this.patientAge,
      patientCondition: patientCondition ?? this.patientCondition,
      patientBloodGroup: patientBloodGroup ?? this.patientBloodGroup,
      patientEmergencyContact:
          patientEmergencyContact ?? this.patientEmergencyContact,
    );
  }
}

class SafeZoneSettings {
  final bool enabled;
  final double radiusMeters;
  final String centerLabel;

  const SafeZoneSettings({
    required this.enabled,
    required this.radiusMeters,
    required this.centerLabel,
  });
}

class NotificationSettings {
  final bool sosAlerts;
  final bool geofenceBreaches;
  final bool medicationReminders;
  final bool dailyHealthSummary;
  final bool lowBattery;

  const NotificationSettings({
    required this.sosAlerts,
    required this.geofenceBreaches,
    required this.medicationReminders,
    required this.dailyHealthSummary,
    required this.lowBattery,
  });

  NotificationSettings copyWith({
    bool? sosAlerts,
    bool? geofenceBreaches,
    bool? medicationReminders,
    bool? dailyHealthSummary,
    bool? lowBattery,
  }) {
    return NotificationSettings(
      sosAlerts: sosAlerts ?? this.sosAlerts,
      geofenceBreaches: geofenceBreaches ?? this.geofenceBreaches,
      medicationReminders: medicationReminders ?? this.medicationReminders,
      dailyHealthSummary: dailyHealthSummary ?? this.dailyHealthSummary,
      lowBattery: lowBattery ?? this.lowBattery,
    );
  }
}

// ─── Mock API Service ──────────────────────────────────────────────────────

class ProfileApiService {
  static Future<UserProfile> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with real API call e.g. http.get(Uri.parse('$baseUrl/profile'))
    return const UserProfile(
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

  static Future<void> updateProfile(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: PUT /api/profile with profile data
  }

  static Future<void> updateSafeZone(SafeZoneSettings settings) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: PUT /api/safe-zone
  }

  static Future<void> updateNotifications(NotificationSettings s) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: PUT /api/notifications
  }
}

// ─── Profile Settings View ─────────────────────────────────────────────────

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<UserProfile> _profileFuture;

  SafeZoneSettings _safeZone = const SafeZoneSettings(
    enabled: true,
    radiusMeters: 200,
    centerLabel: 'Home – 12 Maplewood Drive',
  );

  NotificationSettings _notifications = const NotificationSettings(
    sosAlerts: true,
    geofenceBreaches: true,
    medicationReminders: true,
    dailyHealthSummary: false,
    lowBattery: true,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _profileFuture = ProfileApiService.fetchProfile();
  }

  // ─── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,

      automaticallyImplyLeading: false,
        elevation: 0,
        title: AppText('Profile & Settings',
            size: 18,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700),
            actions: [
                GestureDetector(
                      onTap: () async {
                        final profile = await _profileFuture;
                        if (!mounted) return;
                        _showEditProfileSheet(profile);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.h, vertical: 8.v),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AppText('Edit',
                            size: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(width: 16),
            ],
      ),
      backgroundColor: const Color(0xFFF5F7FB),
      body: FutureBuilder<UserProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoader();
          }
          if (snapshot.hasError) {
            return _buildError();
          }
          return _buildContent(snapshot.requireData);
        },
      ),
    );
  }

  // ─── Main Content ──────────────────────────────────────────────────────

  Widget _buildContent(UserProfile profile) {
    return CustomScrollView(
      slivers: [
        _buildSliverHeader(profile),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 32.v),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Gap.v(20),
              _buildPatientInfoCard(profile),
              Gap.v(16),
              _buildCaregiverInfoCard(profile),
              Gap.v(16),
              _buildSafeZoneCard(),
              Gap.v(16),
              _buildNotificationsCard(),
              Gap.v(16),
              _buildAccountCard(),
              Gap.v(24),
            ]),
          ),
        ),
      ],
    );
  }

  // ─── Sliver Header ─────────────────────────────────────────────────────

  Widget _buildSliverHeader(UserProfile profile) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 12,
                offset: Offset(0, 4)),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.h, 12.v, 20.h, 24.v),
            child: Column(
              children: [
                // Top bar
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () => Navigator.pop(context),
                    //   child: Container(
                    //     width: 40.h,
                    //     height: 40.h,
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xFFF5F7FB),
                    //       borderRadius: BorderRadius.circular(12),
                    //     ),
                    //     child: Icon(Icons.arrow_back_ios_new_rounded,
                    //         size: 18.h, color: AppColors.textDark),
                    //   ),
                    // ),
                  
                 
                  ],
                ),

                SizedBox(height: 24.v),

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 80.h,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(Icons.person_rounded,
                          color: Colors.white, size: 38.h),
                    ),
                    Container(
                      width: 26.h,
                      height: 26.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFF5F7FB), width: 2),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4)
                        ],
                      ),
                      child: Icon(Icons.camera_alt_rounded,
                          size: 14.h, color: AppColors.textDark),
                    ),
                  ],
                ),

                SizedBox(height: 12.v),

                AppText(
                  profile.caregiverName,
                  size: 20,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4.v),
                AppText(
                  profile.caregiverEmail,
                  size: 13,
                  color: AppColors.iconGrey,
                ),

                SizedBox(height: 16.v),

                // Stat pills
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _statPill(Icons.shield_rounded, 'Caregiver',
                        AppColors.primary),
                    SizedBox(width: 10.h),
                    _statPill(Icons.verified_rounded, 'Verified',
                        const Color(0xFF10B981)),
                    SizedBox(width: 10.h),
                    _statPill(Icons.notifications_active_rounded, 'Alerts On',
                        const Color(0xFFF59E0B)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statPill(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.v),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.h, color: color),
          SizedBox(width: 5.h),
          AppText(label,
              size: 11, color: color, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  // ─── Patient Info Card ─────────────────────────────────────────────────

  Widget _buildPatientInfoCard(UserProfile profile) {
    return _SectionCard(
      title: 'Patient Information',
      icon: Icons.elderly_rounded,
      iconColor: const Color(0xFF8B5CF6),
      iconBg: const Color(0xFFF5F3FF),
      children: [
        _infoRow('Full Name', profile.patientName,
            Icons.person_outline_rounded),
        _divider(),
        _infoRow('Age', '${profile.patientAge} years', Icons.cake_outlined),
        _divider(),
        _infoRow('Condition', profile.patientCondition,
            Icons.medical_information_outlined),
        _divider(),
        _infoRow('Blood Group', profile.patientBloodGroup,
            Icons.bloodtype_outlined),
        _divider(),
        _infoRow('Emergency Contact', profile.patientEmergencyContact,
            Icons.contact_phone_outlined),
      ],
    );
  }

  // ─── Caregiver Info Card ───────────────────────────────────────────────

  Widget _buildCaregiverInfoCard(UserProfile profile) {
    return _SectionCard(
      title: 'Caregiver Information',
      icon: Icons.manage_accounts_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primary.withOpacity(0.1),
      children: [
        _infoRow(
            'Name', profile.caregiverName, Icons.person_outline_rounded),
        _divider(),
        _infoRow('Email', profile.caregiverEmail, Icons.email_outlined),
        _divider(),
        _infoRow('Phone', profile.caregiverPhone, Icons.phone_outlined),
      ],
    );
  }

  // ─── Safe Zone Card ────────────────────────────────────────────────────

  Widget _buildSafeZoneCard() {
    return _SectionCard(
      title: 'Safe Zone (Geofencing)',
      icon: Icons.location_on_rounded,
      iconColor: const Color(0xFF3B82F6),
      iconBg: const Color(0xFFEFF6FF),
      children: [
        _toggleRow(
          label: 'Enable Safe Zone',
          subtitle: 'Alert when patient leaves zone',
          value: _safeZone.enabled,
          onChanged: (v) {
            setState(() {
              _safeZone = SafeZoneSettings(
                enabled: v,
                radiusMeters: _safeZone.radiusMeters,
                centerLabel: _safeZone.centerLabel,
              );
            });
            ProfileApiService.updateSafeZone(_safeZone);
          },
        ),
        if (_safeZone.enabled) ...[
          _divider(),
          // Zone center row
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.v),
            child: Row(
              children: [
                Icon(Icons.home_rounded,
                    size: 18.h, color: const Color(0xFF3B82F6)),
                SizedBox(width: 12.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('Zone Center',
                          size: 11,
                          color: AppColors.iconGrey,
                          fontWeight: FontWeight.w500),
                      SizedBox(height: 2.v),
                      AppText(_safeZone.centerLabel,
                          size: 13,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _showSetZoneCenterSheet,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.h, vertical: 5.v),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppText('Change',
                        size: 11,
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          _divider(),
          // Radius slider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText('Safe Radius',
                        size: 13,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.h, vertical: 4.v),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: AppText(
                        '${_safeZone.radiusMeters.toInt()} m',
                        size: 12,
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.v),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF3B82F6),
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                    thumbColor: const Color(0xFF3B82F6),
                    overlayColor: const Color(0x193B82F6),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    value: _safeZone.radiusMeters,
                    onChanged: (v) => setState(() {
                      _safeZone = SafeZoneSettings(
                        enabled: _safeZone.enabled,
                        radiusMeters: v,
                        centerLabel: _safeZone.centerLabel,
                      );
                    }),
                    onChangeEnd: (_) =>
                        ProfileApiService.updateSafeZone(_safeZone),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText('50 m', size: 10, color: AppColors.iconGrey),
                    AppText('1000 m', size: 10, color: AppColors.iconGrey),
                  ],
                ),
              ],
            ),
          ),
          _divider(),
          // Map preview
          GestureDetector(
            // onTap: () => Navigator.pushNamed(context, '/map-picker'),
            child: Container(
              height: 110.v,
              margin: EdgeInsets.only(top: 12.v, bottom: 4.v),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFBFDBFE), width: 1.5),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_rounded,
                            size: 36.h,
                            color: const Color(0xFF93C5FD)),
                        SizedBox(height: 6.v),
                        AppText('Tap to open map & set zone',
                            size: 12,
                            color: const Color(0xFF3B82F6),
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.h, vertical: 4.v),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText('Open Map',
                          size: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ─── Notifications Card ────────────────────────────────────────────────

  Widget _buildNotificationsCard() {
    return _SectionCard(
      title: 'Notification Settings',
      icon: Icons.notifications_rounded,
      iconColor: const Color(0xFFF59E0B),
      iconBg: const Color(0xFFFFFBEB),
      children: [
        _toggleRow(
          label: 'SOS Alerts',
          subtitle: 'Critical — always recommended',
          value: _notifications.sosAlerts,
          onChanged: (v) =>
              _updateNotif(_notifications.copyWith(sosAlerts: v)),
          activeColor: AppColors.alert,
        ),
        _divider(),
        _toggleRow(
          label: 'Geofence Breaches',
          subtitle: 'Patient leaves safe zone',
          value: _notifications.geofenceBreaches,
          onChanged: (v) =>
              _updateNotif(_notifications.copyWith(geofenceBreaches: v)),
          activeColor: const Color(0xFF3B82F6),
        ),
        _divider(),
        _toggleRow(
          label: 'Medication Reminders',
          subtitle: 'Dose schedule alerts',
          value: _notifications.medicationReminders,
          onChanged: (v) =>
              _updateNotif(_notifications.copyWith(medicationReminders: v)),
          activeColor: const Color(0xFF10B981),
        ),
        _divider(),
        _toggleRow(
          label: 'Daily Health Summary',
          subtitle: 'Morning health report',
          value: _notifications.dailyHealthSummary,
          onChanged: (v) =>
              _updateNotif(_notifications.copyWith(dailyHealthSummary: v)),
        ),
        _divider(),
        _toggleRow(
          label: 'Low Battery Alerts',
          subtitle: 'Device battery below 20%',
          value: _notifications.lowBattery,
          onChanged: (v) =>
              _updateNotif(_notifications.copyWith(lowBattery: v)),
        ),
      ],
    );
  }

  // ─── Account / Danger Zone ─────────────────────────────────────────────

  Widget _buildAccountCard() {
    return _SectionCard(
      title: 'Account',
      icon: Icons.settings_rounded,
      iconColor: AppColors.iconGrey,
      iconBg: const Color(0xFFF1F5F9),
      children: [
        _actionRow('Change Password', Icons.lock_outline_rounded,
            AppColors.textDark, () {/* TODO */}),
        _divider(),
        _actionRow('Privacy Policy', Icons.privacy_tip_outlined,
            AppColors.textDark, () {/* TODO */}),
        _divider(),
        _actionRow('Sign Out', Icons.logout_rounded,
            const Color(0xFFF59E0B), _confirmSignOut),
        _divider(),
        _actionRow('Delete Account', Icons.delete_forever_rounded,
            AppColors.alert, _confirmDeleteAccount),
      ],
    );
  }

  // ─── Shared Row Widgets ────────────────────────────────────────────────

  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.v),
      child: Row(
        children: [
          Icon(icon, size: 18.h, color: AppColors.iconGrey),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(label,
                    size: 11,
                    color: AppColors.iconGrey,
                    fontWeight: FontWeight.w500),
                SizedBox(height: 2.v),
                AppText(value,
                    size: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color? activeColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.v),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(label,
                    size: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600),
                SizedBox(height: 2.v),
                AppText(subtitle,
                    size: 11,
                    color: AppColors.iconGrey,
                    fontWeight: FontWeight.w400),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? AppColors.primary,
              activeTrackColor:
                  (activeColor ?? AppColors.primary).withOpacity(0.2),
              inactiveThumbColor: const Color(0xFFCBD5E1),
              inactiveTrackColor: const Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionRow(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13.v),
        child: Row(
          children: [
            Icon(icon, size: 20.h, color: color),
            SizedBox(width: 12.h),
            Expanded(
              child: AppText(label,
                  size: 13, color: color, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 18.h, color: AppColors.iconGrey),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(
        height: 1,
        thickness: 1,
        color: Color(0xFFF1F5F9),
      );

  // ─── Actions ──────────────────────────────────────────────────────────

  void _updateNotif(NotificationSettings ns) {
    setState(() => _notifications = ns);
    ProfileApiService.updateNotifications(ns);
  }

  void _showEditProfileSheet(UserProfile profile) {
    final nameCtrl = TextEditingController(text: profile.caregiverName);
    final phoneCtrl = TextEditingController(text: profile.caregiverPhone);
    final patientNameCtrl =
        TextEditingController(text: profile.patientName);
    final conditionCtrl =
        TextEditingController(text: profile.patientCondition);
    final emergencyCtrl =
        TextEditingController(text: profile.patientEmergencyContact);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        nameCtrl: nameCtrl,
        phoneCtrl: phoneCtrl,
        patientNameCtrl: patientNameCtrl,
        conditionCtrl: conditionCtrl,
        emergencyCtrl: emergencyCtrl,
        onSave: () async {
          Navigator.pop(context);
          final updated = profile.copyWith(
            caregiverName: nameCtrl.text.trim(),
            caregiverPhone: phoneCtrl.text.trim(),
            patientName: patientNameCtrl.text.trim(),
            patientCondition: conditionCtrl.text.trim(),
            patientEmergencyContact: emergencyCtrl.text.trim(),
          );
          await ProfileApiService.updateProfile(updated);
          setState(() => _profileFuture = Future.value(updated));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppText('Profile updated successfully',
                    size: 13, color: Colors.white),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
      ),
    );
  }

  void _showSetZoneCenterSheet() {
    // TODO: open address search / GPS picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText('Open map to set zone center',
            size: 13, color: Colors.white),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _confirmSignOut() {
    _showConfirmDialog(
      title: 'Sign Out',
      message: 'You will need to sign in again to access LifeLinker.',
      confirmLabel: 'Sign Out',
      confirmColor: const Color(0xFFF59E0B),
      onConfirm: () =>
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
    );
  }

  void _confirmDeleteAccount() {
    _showConfirmDialog(
      title: 'Delete Account',
      message:
          'This will permanently delete all data. This action cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: AppColors.alert,
      onConfirm: () {/* TODO: API call then navigate to onboarding */},
    );
  }

  void _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(title,
            size: 16,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700),
        content: AppText(message, size: 13, color: AppColors.iconGrey),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText('Cancel',
                size: 13,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: AppText(confirmLabel,
                size: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );

  Widget _buildError() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48.h, color: AppColors.iconGrey),
            SizedBox(height: 12.v),
            AppText('Failed to load profile',
                size: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600),
            SizedBox(height: 8.v),
            TextButton(
              onPressed: () => setState(
                  () => _profileFuture = ProfileApiService.fetchProfile()),
              child: AppText('Retry',
                  size: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}

// ─── Section Card ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 0),
            child: Row(
              children: [
                Container(
                  width: 34.h,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 18.h),
                ),
                SizedBox(width: 10.h),
                AppText(title,
                    size: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Column(children: children),
          ),
          SizedBox(height: 4.v),
        ],
      ),
    );
  }
}

// ─── Edit Profile Bottom Sheet ─────────────────────────────────────────────

class _EditProfileSheet extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController patientNameCtrl;
  final TextEditingController conditionCtrl;
  final TextEditingController emergencyCtrl;
  final VoidCallback onSave;

  const _EditProfileSheet({
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.patientNameCtrl,
    required this.conditionCtrl,
    required this.emergencyCtrl,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.h, 20.v, 20.h, 32.v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.h,
                height: 4.v,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16.v),
            AppText('Edit Profile',
                size: 18,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700),
            SizedBox(height: 20.v),
            _label('Caregiver'),
            SizedBox(height: 10.v),
            _field('Your Name', nameCtrl, Icons.person_outline_rounded),
            SizedBox(height: 12.v),
            _field('Your Phone', phoneCtrl, Icons.phone_outlined,
                keyboardType: TextInputType.phone),
            SizedBox(height: 20.v),
            _label('Patient'),
            SizedBox(height: 10.v),
            _field('Patient Name', patientNameCtrl, Icons.elderly_rounded),
            SizedBox(height: 12.v),
            _field('Condition', conditionCtrl,
                Icons.medical_information_outlined),
            SizedBox(height: 12.v),
            _field('Emergency Contact', emergencyCtrl,
                Icons.contact_phone_outlined,
                keyboardType: TextInputType.phone),
            SizedBox(height: 28.v),
            SizedBox(
              width: double.infinity,
              height: 52.v,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: AppText('Save Changes',
                    size: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => AppText(text,
      size: 12,
      color: AppColors.iconGrey,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5);

  Widget _field(
    String hint,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(
          fontSize: 14,
          color: AppColors.textDark,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(fontSize: 13, color: AppColors.iconGrey),
        prefixIcon: Icon(icon, size: 18.h, color: AppColors.iconGrey),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.v),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}