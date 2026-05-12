import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/caregiver/add%20edit%20patient/add_edit_patient.dart';

class PatientDetailsView extends StatefulWidget {
  final UserModel patient;
  const PatientDetailsView({super.key, required this.patient});

  @override
  State<PatientDetailsView> createState() => _PatientDetailsViewState();
}

class _PatientDetailsViewState extends State<PatientDetailsView> {
  late UserModel _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4,
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                  _buildQuickStats(),
                  SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                  _buildInfoSection(
                    title: 'Medical Information',
                    icon: Icons.medical_information_rounded,
                    iconColor: AppColors.purple,
                    iconBg: AppColors.purpleLight,
                    children: [
                      _InfoTile(
                        icon: Icons.coronavirus_outlined,
                        label: 'Condition',
                        value: _patient.condition ?? 'Not specified',
                        valueColor: AppColors.textDark,
                      ),
                      _InfoTile(
                        icon: Icons.bloodtype_outlined,
                        label: 'Blood Group',
                        value: _patient.bloodGroup ?? 'Not specified',
                        valueColor: AppColors.alert,
                        valueBold: true,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                  _buildInfoSection(
                    title: 'Personal Details',
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColors.blue,
                    iconBg: AppColors.blueLight,
                    children: [
                      _InfoTile(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: _patient.dob ?? 'Not specified',
                        valueColor: AppColors.textDark,
                      ),
                      _InfoTile(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: _patient.email.isEmpty
                            ? 'Not specified'
                            : _patient.email,
                        valueColor: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                  _buildInfoSection(
                    title: 'Contact Information',
                    icon: Icons.contact_phone_outlined,
                    iconColor: AppColors.successDark,
                    iconBg: AppColors.successLight,
                    children: [
                      _InfoTile(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: _patient.phone ?? 'Not specified',
                        valueColor: AppColors.textDark,
                      ),
                      _InfoTile(
                        icon: Icons.emergency_outlined,
                        label: 'Emergency',
                        value: _patient.emergencyContact ?? 'Not specified',
                        valueColor: AppColors.textDark,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 3),
                  _buildActionsGrid(context),
                  SizedBox(height: SizeConfig.heightMultiplier * 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sliver Header with gradient + avatar ──────────────────────────────────

  Widget _buildSliverHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: SizeConfig.heightMultiplier * 30,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context, _patient),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier * 2),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: SizeConfig.widthMultiplier * 4.5,
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: _openEdit,
          child: Padding(
            padding: EdgeInsets.only(right: SizeConfig.widthMultiplier * 4),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 3,
                vertical: SizeConfig.heightMultiplier * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: SizeConfig.widthMultiplier * 3.8,
                  ),
                  SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                  AppText(
                    'Edit',
                    size: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -SizeConfig.widthMultiplier * 10,
                right: -SizeConfig.widthMultiplier * 10,
                child: Container(
                  width: SizeConfig.widthMultiplier * 50,
                  height: SizeConfig.widthMultiplier * 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: SizeConfig.heightMultiplier * 5,
                left: -SizeConfig.widthMultiplier * 8,
                child: Container(
                  width: SizeConfig.widthMultiplier * 35,
                  height: SizeConfig.widthMultiplier * 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              // Avatar + name
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.heightMultiplier * 3,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar
                      Container(
                        width: SizeConfig.widthMultiplier * 24,
                        height: SizeConfig.widthMultiplier * 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.6),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          image: _patient.profileImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    _patient.profileImageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _patient.profileImageUrl == null
                            ? Icon(
                                Icons.person_rounded,
                                color: AppColors.primary,
                                size: SizeConfig.widthMultiplier * 12,
                              )
                            : null,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                      AppText(
                        _patient.name,
                        size: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 4,
                          vertical: SizeConfig.heightMultiplier * 0.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.22),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AppText(
                          'Patient',
                          size: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Quick Stats row ───────────────────────────────────────────────────────

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.bloodtype_rounded,
            iconColor: AppColors.alert,
            iconBg: AppColors.alertLight,
            label: 'Blood Group',
            value: _patient.bloodGroup ?? '—',
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 3),
        Expanded(
          child: _StatCard(
            icon: Icons.coronavirus_rounded,
            iconColor: AppColors.purple,
            iconBg: AppColors.purpleLight,
            label: 'Condition',
            value: _patient.condition ?? '—',
            smallValue: true,
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 3),
        Expanded(
          child: _StatCard(
            icon: Icons.cake_rounded,
            iconColor: AppColors.amber,
            iconBg: AppColors.amberLight,
            label: 'Age',
            value: _getAge(),
          ),
        ),
      ],
    );
  }

  String _getAge() {
    if (_patient.dob == null || _patient.dob!.isEmpty) return '—';
    try {
      final parts = _patient.dob!.split('/');
      if (parts.length == 3) {
        final dob = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        final age = DateTime.now().difference(dob).inDays ~/ 365;
        return '${age}y';
      }
    } catch (_) {}
    return '—';
  }

  // ── Info section card ─────────────────────────────────────────────────────

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.widthMultiplier * 4,
              SizeConfig.heightMultiplier * 2,
              SizeConfig.widthMultiplier * 4,
              SizeConfig.heightMultiplier * 1.5,
            ),
            child: Row(
              children: [
                Container(
                  width: SizeConfig.widthMultiplier * 9,
                  height: SizeConfig.widthMultiplier * 9,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: SizeConfig.widthMultiplier * 5,
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 3),
                AppText(
                  title,
                  size: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          Container(height: 0.5, color: AppColors.dividerLight),
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.widthMultiplier * 4,
              SizeConfig.heightMultiplier * 0.5,
              SizeConfig.widthMultiplier * 4,
              SizeConfig.heightMultiplier * 1,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // ── Actions Grid ──────────────────────────────────────────────────────────

  Widget _buildActionsGrid(BuildContext context) {
    final caregiverId = SharedPrefsService.getUID() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Quick Actions',
          size: 16,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1.5),
        // Monitor Live — full width, prominent
        _ActionButton(
          icon: Icons.videocam_rounded,
          label: 'Monitor Live',
          subtitle: 'Start real-time monitoring',
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => AppRouter.push(
            context,
            RouteNames.caregiverMonitor,
            arguments: {'patient': _patient, 'caregiverId': caregiverId},
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 1.5),
        // 2x2 grid for remaining 4 actions
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: SizeConfig.widthMultiplier * 3,
          mainAxisSpacing: SizeConfig.heightMultiplier * 1.5,
          childAspectRatio: 1.55,
          children: [
            _GridActionCard(
              icon: Icons.medication_rounded,
              label: 'Medications',
              color: AppColors.medicationViolet,
              bg: const Color(0xFFF0EDFF),
              onTap: () => AppRouter.push(
                context,
                RouteNames.caregiverMedication,
                arguments: _patient,
              ),
            ),
            _GridActionCard(
              icon: Icons.favorite_rounded,
              label: 'Health Records',
              color: AppColors.alert,
              bg: AppColors.alertLight,
              onTap: () => AppRouter.push(
                context,
                RouteNames.caregiverHealth,
                arguments: _patient,
              ),
            ),
            _GridActionCard(
              icon: Icons.restaurant_menu_rounded,
              label: 'Diet Plan',
              color: AppColors.successDark,
              bg: AppColors.successLight,
              onTap: () => AppRouter.push(
                context,
                RouteNames.caregiverDiet,
                arguments: _patient,
              ),
            ),
            _GridActionCard(
              icon: Icons.bedtime_rounded,
              label: 'Sleep Routine',
              color: AppColors.primary,
              bg: const Color(0xFFEFF6FF),
              onTap: () => AppRouter.push(
                context,
                RouteNames.caregiverSleep,
                arguments: _patient,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openEdit() async {
    final updated = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditPatientView(existingPatient: _patient),
      ),
    );
    if (updated != null) {
      setState(() => _patient = updated);
    }
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final bool smallValue;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3,
        vertical: SizeConfig.heightMultiplier * 1.8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 9,
            height: SizeConfig.widthMultiplier * 9,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: SizeConfig.widthMultiplier * 4.5,
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText(
            value,
            size: smallValue ? 12 : 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 0.3),
          AppText(label, size: 10, color: AppColors.iconGrey),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool valueBold;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.2,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: SizeConfig.widthMultiplier * 5,
            color: AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  label,
                  size: 13,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w500,
                ),
                Flexible(
                  child: AppText(
                    value,
                    size: 13,
                    color: valueColor,
                    fontWeight: valueBold ? FontWeight.w700 : FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    align: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 5,
          vertical: SizeConfig.heightMultiplier * 2,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 12,
              height: SizeConfig.widthMultiplier * 12,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: SizeConfig.widthMultiplier * 6.5,
              ),
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  size: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                AppText(
                  subtitle,
                  size: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.7),
              size: SizeConfig.widthMultiplier * 4.5,
            ),
          ],
        ),
      ),
    );
  }
}

class _GridActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _GridActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowStrong,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 11,
              height: SizeConfig.widthMultiplier * 11,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: SizeConfig.widthMultiplier * 5.5,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    label,
                    size: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.iconGrey,
                  size: SizeConfig.widthMultiplier * 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
