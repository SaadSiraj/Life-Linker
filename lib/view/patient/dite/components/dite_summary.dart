import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dite_plan.dart';

class PatientDietSummary extends StatelessWidget {
  final DietPlanModel plan;

  const PatientDietSummary({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.successDark, AppColors.success],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu_rounded,
                color: Colors.white,
                size: SizeConfig.widthMultiplier * 6,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Expanded(
                child: AppText(
                  plan.title,
                  size: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (plan.description != null && plan.description!.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 0.8),
            AppText(
              plan.description!,
              size: 12,
              color: Colors.white.withOpacity(0.85),
            ),
          ],
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            children: [
              _SummaryStat(
                icon: Icons.local_fire_department_rounded,
                label: 'Daily Calories',
                value: '${plan.totalDailyCalories} kcal',
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 4),
              _SummaryStat(
                icon: Icons.restaurant_rounded,
                label: 'Total Meals',
                value: '${plan.meals.length} meals',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            color: Colors.white.withOpacity(0.85),
            size: SizeConfig.widthMultiplier * 4),
        SizedBox(width: SizeConfig.widthMultiplier * 1.5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              value,
              size: 13,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            AppText(
              label,
              size: 10,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ],
    );
  }
}