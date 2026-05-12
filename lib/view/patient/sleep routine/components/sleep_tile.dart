import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sleep_log.dart';
import 'package:lifelinker/model/sleep_routine.dart';

class PatientSleepRoutineTile extends StatelessWidget {
  final SleepRoutineModel routine;
  final SleepLogModel? todayLog;
  final VoidCallback onLogSleep;

  const PatientSleepRoutineTile({
    super.key,
    required this.routine,
    required this.todayLog,
    required this.onLogSleep,
  });

  @override
  Widget build(BuildContext context) {
    final hasLogged = todayLog != null;

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
                  color: AppColors.medicationViolet.withOpacity(0.1),
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
                    AppText(
                      '${routine.bedtime}  →  ${routine.wakeTime}',
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  ],
                ),
              ),
              if (hasLogged)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 2.5,
                    vertical: SizeConfig.heightMultiplier * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    'Logged',
                    size: 10,
                    color: AppColors.successDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          if (hasLogged) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1.2),
            Divider(color: AppColors.divider, height: 1),
            SizedBox(height: SizeConfig.heightMultiplier * 1.2),
            Row(
              children: [
                _LogStat(
                  label: 'Slept',
                  value: '${todayLog!.actualHours}h',
                  color: AppColors.medicationViolet,
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 4),
                _LogStat(
                  label: 'Quality',
                  value: todayLog!.qualityLabel,
                  color: _qualityColor(todayLog!.quality),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 4),
                _LogStat(
                  label: 'Status',
                  value: todayLog!.metTarget ? 'On Track' : 'Low',
                  color: todayLog!.metTarget
                      ? AppColors.successDark
                      : AppColors.alert,
                ),
              ],
            ),
            if (todayLog!.notes != null &&
                todayLog!.notes!.isNotEmpty) ...[
              SizedBox(height: SizeConfig.heightMultiplier * 0.8),
              AppText(
                todayLog!.notes!,
                size: 11,
                color: AppColors.iconGrey,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ] else ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onLogSleep,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.heightMultiplier * 1.3),
                  decoration: BoxDecoration(
                    color: AppColors.medicationViolet,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: SizeConfig.widthMultiplier * 5,
                      ),
                      SizedBox(
                          width: SizeConfig.widthMultiplier * 1.5),
                      AppText(
                        'Log Today\'s Sleep',
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
          if (routine.sleepTips.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            Divider(color: AppColors.divider, height: 1),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            AppText(
              'Tips from Caregiver',
              size: 12,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.6),
            ...routine.sleepTips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.heightMultiplier * 0.4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      size: SizeConfig.widthMultiplier * 3.5,
                      color: AppColors.amber,
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
        ],
      ),
    );
  }

  Color _qualityColor(SleepQuality q) {
    switch (q) {
      case SleepQuality.excellent:
        return AppColors.successDark;
      case SleepQuality.good:
        return AppColors.primary;
      case SleepQuality.fair:
        return AppColors.amber;
      case SleepQuality.poor:
        return AppColors.alert;
    }
  }
}

class _LogStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _LogStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          value,
          size: 14,
          color: color,
          fontWeight: FontWeight.w700,
        ),
        AppText(label, size: 10, color: AppColors.iconGrey),
      ],
    );
  }
}