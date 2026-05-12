import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dite_plan.dart';
import 'package:lifelinker/view/patient/dite/components/meal_row.dart';

class PatientDietCard extends StatelessWidget {
  final DietPlanModel plan;

  const PatientDietCard({super.key, required this.plan});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                plan.title,
                size: 15,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
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
                  '${plan.totalDailyCalories} kcal/day',
                  size: 10,
                  color: AppColors.successDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Divider(color: AppColors.divider, height: 1),
          SizedBox(height: SizeConfig.heightMultiplier * 1.2),
          ...plan.meals.map((meal) => PatientMealRow(meal: meal)),
        ],
      ),
    );
  }
}