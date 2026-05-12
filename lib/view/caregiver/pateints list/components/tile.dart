import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/caregiver/pateints%20list/components/info_chip.dart';

class PatientTile extends StatelessWidget {
  final UserModel patient;
  final VoidCallback onTap;

  const PatientTile({super.key, required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 4,
          vertical: SizeConfig.heightMultiplier * 1.6,
        ),
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
          children: [
            Row(
              children: [
                _PatientAvatar(patient: patient),
                SizedBox(width: SizeConfig.widthMultiplier * 3.5),
                Expanded(child: _PatientInfo(patient: patient)),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.iconGrey,
                  size: SizeConfig.widthMultiplier * 5.5,
                ),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1.4),
            Container(height: 0.5, color: AppColors.dividerLight),
            SizedBox(height: SizeConfig.heightMultiplier * 1.2),
            _ActionRow(patient: patient),
          ],
        ),
      ),
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  final UserModel patient;

  const _PatientAvatar({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier * 13,
      height: SizeConfig.widthMultiplier * 13,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
          width: 1.5,
        ),
        image: patient.profileImageUrl != null
            ? DecorationImage(
                image: NetworkImage(patient.profileImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: patient.profileImageUrl == null
          ? Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 6.5,
            )
          : null,
    );
  }
}

class _PatientInfo extends StatelessWidget {
  final UserModel patient;

  const _PatientInfo({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          patient.name,
          size: 15,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (patient.condition != null) ...[
          SizedBox(height: SizeConfig.heightMultiplier * 0.3),
          AppText(
            patient.condition!,
            size: 12,
            color: AppColors.iconGrey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: SizeConfig.heightMultiplier * 0.6),
        Row(
          children: [
            if (patient.bloodGroup != null) ...[
              PatientInfoChip(
                label: patient.bloodGroup!,
                color: AppColors.alertLight,
                textColor: AppColors.alert,
                icon: Icons.bloodtype_outlined,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
            ],
            if (patient.dob != null)
              PatientInfoChip(
                label: patient.dob!,
                color: AppColors.blueLight,
                textColor: AppColors.blue,
                icon: Icons.cake_outlined,
              ),
          ],
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final UserModel patient;

  const _ActionRow({required this.patient});

  @override
  Widget build(BuildContext context) {
    final caregiverId = SharedPrefsService.getUID() ?? '';

    return Row(
      children: [
        _TileActionBtn(
          icon: Icons.videocam_rounded,
          label: 'Live',
          color: AppColors.successDark,
          bg: AppColors.successLight,
          onTap: () => AppRouter.push(
            context,
            RouteNames.caregiverMonitor,
            arguments: {'patient': patient, 'caregiverId': caregiverId},
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2),
        _TileActionBtn(
          icon: Icons.medication_rounded,
          label: 'Meds',
          color: AppColors.medicationViolet,
          bg: const Color(0xFFF0EDFF),
          onTap: () => AppRouter.push(
            context,
            RouteNames.caregiverMedication,
            arguments: patient,
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2),
        _TileActionBtn(
          icon: Icons.favorite_rounded,
          label: 'Health',
          color: AppColors.alert,
          bg: AppColors.alertLight,
          onTap: () => AppRouter.push(
            context,
            RouteNames.caregiverHealth,
            arguments: patient,
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2),
        _TileActionBtn(
          icon: Icons.restaurant_menu_rounded,
          label: 'Diet',
          color: AppColors.successDark,
          bg: AppColors.successLight,
          onTap: () => AppRouter.push(
            context,
            RouteNames.caregiverDiet,
            arguments: patient,
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2),
        _TileActionBtn(
          icon: Icons.bedtime_rounded,
          label: 'Sleep',
          color: AppColors.primary,
          bg: const Color(0xFFEFF6FF),
          onTap: () => AppRouter.push(
            context,
            RouteNames.caregiverSleep,
            arguments: patient,
          ),
        ),
      ],
    );
  }
}

class _TileActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _TileActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 0.9,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: SizeConfig.widthMultiplier * 4.5),
              SizedBox(height: SizeConfig.heightMultiplier * 0.3),
              AppText(
                label,
                size: 9,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}