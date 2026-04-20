import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/spleep.dart';
import 'package:lifelinker/view/health_monitoring/components/health_card.dart';

class SleepCard extends StatelessWidget {
  final SleepModel sleep;

  const SleepCard({super.key, required this.sleep});

  @override
  Widget build(BuildContext context) {
    return HealthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'Sleep',
                size: 16,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    '${sleep.totalHours}',
                    size: 22,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                    'h',
                    size: 14,
                    color: AppColors.iconGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ],
          ),
          Gap.v(4),
          AppText(sleep.sleepNote, size: 12, color: AppColors.iconGrey),
          Gap.v(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                _SleepSegment(
                  flex: sleep.deepRatio,
                  color: AppColors.primaryDark,
                ),
                _SleepSegment(flex: sleep.coreRatio, color: AppColors.primary),
                _SleepSegment(flex: sleep.remRatio, color: AppColors.sleepRem),
                _SleepSegment(flex: sleep.awakeRatio, color: AppColors.border),
              ],
            ),
          ),
          Gap.v(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SleepLegend(label: 'Deep', color: AppColors.primaryDark),
              _SleepLegend(label: 'Core', color: AppColors.primary),
              _SleepLegend(label: 'REM', color: AppColors.sleepRem),
              _SleepLegend(label: 'Awake', color: AppColors.iconGrey),
            ],
          ),
          Gap.v(12),
          Divider(color: AppColors.divider, height: 1),
          Gap.v(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SleepTimeRow(
                icon: Icons.bedtime_rounded,
                label: 'Bedtime',
                time: sleep.bedtime,
              ),
              Container(width: 1, height: 32.v, color: AppColors.divider),
              _SleepTimeRow(
                icon: Icons.wb_sunny_rounded,
                label: 'Wake up',
                time: sleep.wakeUp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SleepSegment extends StatelessWidget {
  final double flex;
  final Color color;

  const _SleepSegment({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Container(height: 10.v, color: color),
    );
  }
}

class _SleepLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _SleepLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10.h,
          height: 10.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.h),
        AppText(label, size: 11, color: AppColors.iconGrey),
      ],
    );
  }
}

class _SleepTimeRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;

  const _SleepTimeRow({
    required this.icon,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.h),
        SizedBox(width: 8.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(label, size: 11, color: AppColors.iconGrey),
            AppText(
              time,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ],
    );
  }
}
