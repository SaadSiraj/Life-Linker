import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sleep_log.dart';

class PatientSleepWeekChart extends StatelessWidget {
  final List<SleepLogModel> logs;

  const PatientSleepWeekChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final recentLogs = logs.take(7).toList().reversed.toList();
    final maxHours = recentLogs.isEmpty
        ? 10.0
        : recentLogs
            .map((l) => l.actualHours)
            .reduce((a, b) => a > b ? a : b);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'Weekly Sleep',
                size: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
              AppText(
                'Last 7 days',
                size: 11,
                color: AppColors.iconGrey,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
          SizedBox(
            height: SizeConfig.heightMultiplier * 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: recentLogs.map((log) {
                final fraction =
                    maxHours > 0 ? log.actualHours / maxHours : 0.0;
                final isToday = _isToday(log.date);
                return _SleepBar(
                  log: log,
                  fraction: fraction,
                  isToday: isToday,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _SleepBar extends StatelessWidget {
  final SleepLogModel log;
  final double fraction;
  final bool isToday;

  const _SleepBar({
    required this.log,
    required this.fraction,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = isToday
        ? AppColors.medicationViolet
        : AppColors.medicationViolet.withOpacity(0.3);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppText(
          '${log.actualHours}h',
          size: 9,
          color: isToday
              ? AppColors.medicationViolet
              : AppColors.iconGrey,
          fontWeight:
              isToday ? FontWeight.w700 : FontWeight.w400,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.4),
        Container(
          width: SizeConfig.widthMultiplier * 8,
          height:
              (SizeConfig.heightMultiplier * 10 * fraction).clamp(
            SizeConfig.heightMultiplier * 0.5,
            SizeConfig.heightMultiplier * 10,
          ),
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.5),
        AppText(
          '${log.date.day}/${log.date.month}',
          size: 9,
          color:
              isToday ? AppColors.medicationViolet : AppColors.iconGrey,
        ),
      ],
    );
  }
}