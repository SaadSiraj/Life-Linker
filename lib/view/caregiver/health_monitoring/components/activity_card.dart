import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/activity.dart';
import 'package:lifelinker/view/caregiver/health_monitoring/components/health_card.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const ActivityCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return HealthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Activity',
              size: 16, color: AppColors.textDark, fontWeight: FontWeight.w600),
          Gap.v(14),
          Row(
            children: [
              _ActivityStat(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.alert,
                value: '${activity.calories}',
                unit: 'kcal',
                label: 'Calories',
              ),
              SizedBox(width: 10.h),
              _ActivityStat(
                icon: Icons.directions_walk_rounded,
                iconColor: AppColors.primary,
                value: '${activity.distanceKm}',
                unit: 'km',
                label: 'Distance',
              ),
              SizedBox(width: 10.h),
              _ActivityStat(
                icon: Icons.timer_rounded,
                iconColor: AppColors.success,
                value: '${activity.activeMinutes}',
                unit: 'min',
                label: 'Active',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;
  final String label;

  const _ActivityStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.v),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22.h),
            Gap.v(6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(value, size: 15, color: AppColors.textDark, fontWeight: FontWeight.w700),
                AppText(unit, size: 10, color: AppColors.iconGrey),
              ],
            ),
            Gap.v(2),
            AppText(label, size: 11, color: AppColors.iconGrey),
          ],
        ),
      ),
    );
  }
}