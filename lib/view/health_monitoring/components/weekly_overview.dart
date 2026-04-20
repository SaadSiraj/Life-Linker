import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/weekly_day.dart';
import 'package:lifelinker/view/health_monitoring/components/health_card.dart';
class WeeklyOverviewCard extends StatelessWidget {
  final List<WeeklyDayModel> weeklyData;

  const WeeklyOverviewCard({super.key, required this.weeklyData});

  @override
  Widget build(BuildContext context) {
    return HealthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Weekly Overview',
                  size: 16, color: AppColors.textDark, fontWeight: FontWeight.w600),
              AppText('Steps',
                  size: 12, color: AppColors.primary, fontWeight: FontWeight.w500),
            ],
          ),
          Gap.v(16),
          SizedBox(
            height: 80.v,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weeklyData.map((d) => _BarColumn(data: d)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final WeeklyDayModel data;

  const _BarColumn({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28.h,
          height: (60 * data.stepsFraction).v,
          decoration: BoxDecoration(
            color: data.isToday
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        Gap.v(6),
        AppText(
          data.day,
          size: 10,
          color: data.isToday ? AppColors.primary : AppColors.iconGrey,
          fontWeight: data.isToday ? FontWeight.w600 : FontWeight.w400,
        ),
      ],
    );
  }
}