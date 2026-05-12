import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sleep_log.dart';
import 'package:lifelinker/model/sleep_routine.dart';

class CaregiverSleepLogsSection extends StatelessWidget {
  final List<SleepLogModel> logs;

  const CaregiverSleepLogsSection({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final avg = logs.isEmpty
        ? 0.0
        : logs.fold(0.0, (s, l) => s + l.actualHours) / logs.length;
    final met = logs.where((l) => l.metTarget).length;

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
              Icon(
                Icons.bar_chart_rounded,
                color: AppColors.medicationViolet,
                size: SizeConfig.widthMultiplier * 5,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              AppText(
                'Last 7 Days Sleep Logs',
                size: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            children: [
              _StatTile(
                label: 'Avg Sleep',
                value: '${avg.toStringAsFixed(1)}h',
                icon: Icons.schedule_rounded,
                color: AppColors.medicationViolet,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              _StatTile(
                label: 'Met Target',
                value: '$met / ${logs.length}',
                icon: Icons.check_circle_rounded,
                color: AppColors.successDark,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          ...logs.take(7).map((log) => _LogRow(log: log)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3,
          vertical: SizeConfig.heightMultiplier * 1.2,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: SizeConfig.widthMultiplier * 5),
            SizedBox(width: SizeConfig.widthMultiplier * 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  value,
                  size: 15,
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
                AppText(label, size: 10, color: AppColors.iconGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  final SleepLogModel log;

  const _LogRow({required this.log});

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

  @override
  Widget build(BuildContext context) {
    final color = _qualityColor(log.quality);
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 0.8),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3,
        vertical: SizeConfig.heightMultiplier * 1,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          AppText(
            '${log.date.day}/${log.date.month}',
            size: 12,
            color: AppColors.iconGrey,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          Icon(
            Icons.bedtime_outlined,
            size: SizeConfig.widthMultiplier * 3.5,
            color: AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          AppText(
            log.actualBedtime,
            size: 11,
            color: AppColors.textMedium,
          ),
          Icon(
            Icons.arrow_forward_rounded,
            size: SizeConfig.widthMultiplier * 3,
            color: AppColors.iconGrey,
          ),
          AppText(
            log.actualWakeTime,
            size: 11,
            color: AppColors.textMedium,
          ),
          const Spacer(),
          AppText(
            '${log.actualHours}h',
            size: 13,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 2,
              vertical: SizeConfig.heightMultiplier * 0.3,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText(
              log.qualityLabel,
              size: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}