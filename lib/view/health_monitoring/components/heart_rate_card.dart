import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/heart_rate.dart';
import 'package:lifelinker/view/health_monitoring/components/health_card.dart';
import 'package:lifelinker/view/health_monitoring/components/heart_rate_chart.dart';

class HeartRateCard extends StatelessWidget {
  final HeartRateModel heartRate;

  const HeartRateCard({super.key, required this.heartRate});

  @override
  Widget build(BuildContext context) {
    return HealthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Heart Rate',
                  size: 16, color: AppColors.textDark, fontWeight: FontWeight.w600),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppText(
                        '${heartRate.currentBpm}',
                        size: 22,
                        color: AppColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                      AppText('BPM',
                          size: 12, color: AppColors.success, fontWeight: FontWeight.w500),
                    ],
                  ),
                  AppText(heartRate.lastReadingTime, size: 11, color: AppColors.iconGrey),
                ],
              ),
            ],
          ),
          Gap.v(14),
          SizedBox(
            height: 80.v,
            child: CustomPaint(
              size: Size(double.infinity, 80.v),
              painter: HeartRateChartPainter(points: heartRate.bpmPoints),
            ),
          ),
          Gap.v(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HRStat(label: 'Min', value: '${heartRate.minBpm}', color: AppColors.primary),
              _HRStat(label: 'Avg', value: '${heartRate.avgBpm}', color: AppColors.success),
              _HRStat(label: 'Max', value: '${heartRate.maxBpm}', color: AppColors.alert),
            ],
          ),
        ],
      ),
    );
  }
}

class _HRStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _HRStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(value, size: 15, color: color, fontWeight: FontWeight.w700),
        AppText(label, size: 11, color: AppColors.iconGrey),
      ],
    );
  }
}