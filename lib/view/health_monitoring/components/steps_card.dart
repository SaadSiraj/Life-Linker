import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/steps.dart';
import 'package:lifelinker/view/health_monitoring/components/health_card.dart';
class StepsCard extends StatelessWidget {
  final StepsModel steps;

  const StepsCard({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return HealthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('Steps',
                  size: 16, color: AppColors.textDark, fontWeight: FontWeight.w600),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    '${steps.currentSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                    size: 22,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText('Set ${steps.goalSteps}',
                      size: 11, color: AppColors.iconGrey, fontWeight: FontWeight.w400),
                ],
              ),
            ],
          ),
          Gap.v(6),
          AppText('Goal of ${steps.goalSteps.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
              size: 12, color: AppColors.iconGrey),
          Gap.v(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: steps.progress,
              minHeight: 10.v,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          ),
          Gap.v(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('0', size: 11, color: AppColors.iconGrey),
              AppText('${steps.goalSteps.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                  size: 11, color: AppColors.iconGrey),
            ],
          ),
        ],
      ),
    );
  }
}