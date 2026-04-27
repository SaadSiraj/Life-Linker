import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/week_log.dart';

class LastWeekLogs extends StatelessWidget {
  final List<WeekLogModel> logs;
  final String adherenceLabel;

  const LastWeekLogs({
    super.key,
    required this.logs,
    required this.adherenceLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Last Week Logs',
            size: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          Gap.v(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: logs.map((log) => _buildDayDot(log)).toList(),
          ),
          Gap.v(12),
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: AppColors.primary, size: 18.h),
              SizedBox(width: 6.h),
              AppText(
                adherenceLabel,
                size: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayDot(WeekLogModel log) {
    return Column(
      children: [
        Container(
          width: 32.h,
          height: 32.h,
          decoration: BoxDecoration(
            color: log.color,
            shape: BoxShape.circle,
          ),
          child: Icon(log.icon, color: Colors.white, size: 16.h),
        ),
        Gap.v(4),
        AppText(log.dayLabel, size: 11, color: AppColors.iconGrey),
      ],
    );
  }
}