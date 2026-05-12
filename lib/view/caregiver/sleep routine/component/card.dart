import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sleep_routine.dart';
import 'package:lifelinker/view/caregiver/sleep%20routine/component/action_button.dart';

class CaregiverSleepRoutineCard extends StatelessWidget {
  final SleepRoutineModel routine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CaregiverSleepRoutineCard({
    super.key,
    required this.routine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 11,
                height: SizeConfig.widthMultiplier * 11,
                decoration: BoxDecoration(
                  color: AppColors.medicationViolet.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bedtime_rounded,
                  color: AppColors.medicationViolet,
                  size: SizeConfig.widthMultiplier * 6,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      routine.title,
                      size: 15,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                    AppText(
                      'Target: ${routine.targetHours}h sleep',
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: SizeConfig.heightMultiplier * 1.2),
          Row(
            children: [
              _TimeBlock(
                icon: Icons.bedtime_outlined,
                label: 'Bedtime',
                time: routine.bedtime,
                color: AppColors.medicationViolet,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 4),
              Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.iconGrey,
                size: SizeConfig.widthMultiplier * 4,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 4),
              _TimeBlock(
                icon: Icons.wb_sunny_outlined,
                label: 'Wake Up',
                time: routine.wakeTime,
                color: AppColors.amber,
              ),
            ],
          ),
          if (routine.sleepTips.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            Divider(color: AppColors.divider, height: 1),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            AppText(
              'Sleep Tips',
              size: 12,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.6),
            ...routine.sleepTips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.heightMultiplier * 0.4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: SizeConfig.widthMultiplier * 3.5,
                      color: AppColors.medicationViolet,
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                    Expanded(
                      child: AppText(
                        tip,
                        size: 11,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SleepActionBtn(
                icon: Icons.edit_rounded,
                label: 'Edit',
                color: AppColors.primary,
                onTap: onEdit,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              SleepActionBtn(
                icon: Icons.delete_outline_rounded,
                label: 'Remove',
                color: AppColors.alert,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _TimeBlock({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: SizeConfig.widthMultiplier * 3.5, color: color),
            SizedBox(width: SizeConfig.widthMultiplier * 1),
            AppText(label, size: 11, color: AppColors.iconGrey),
          ],
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.3),
        AppText(
          time,
          size: 16,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
