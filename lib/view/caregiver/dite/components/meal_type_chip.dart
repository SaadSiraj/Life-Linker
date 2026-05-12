import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dite_plan.dart';

class MealTypeChip extends StatelessWidget {
  final DietMeal meal;

  const MealTypeChip({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2.5,
        vertical: SizeConfig.heightMultiplier * 0.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _mealIcon(meal.type),
            size: SizeConfig.widthMultiplier * 3.5,
            color: AppColors.primary,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          AppText(
            '${meal.typeLabel}  •  ${meal.totalCalories} kcal',
            size: 11,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  IconData _mealIcon(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.wb_sunny_rounded;
      case MealType.lunch:
        return Icons.wb_cloudy_rounded;
      case MealType.dinner:
        return Icons.nights_stay_rounded;
      case MealType.snack:
        return Icons.cookie_rounded;
    }
  }
}