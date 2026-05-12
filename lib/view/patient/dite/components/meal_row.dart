import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dite_plan.dart';

class PatientMealRow extends StatelessWidget {
  final DietMeal meal;

  const PatientMealRow({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1.2),
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 8,
                height: SizeConfig.widthMultiplier * 8,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _mealIcon(meal.type),
                  color: AppColors.primary,
                  size: SizeConfig.widthMultiplier * 4.5,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2.5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      meal.typeLabel,
                      size: 13,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    if (meal.time.isNotEmpty)
                      AppText(meal.time, size: 11, color: AppColors.iconGrey),
                  ],
                ),
              ),
              AppText(
                '${meal.totalCalories} kcal',
                size: 12,
                color: AppColors.successDark,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          if (meal.items.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            ...meal.items.map(
              (item) => Padding(
                padding: EdgeInsets.only(
                  bottom: SizeConfig.heightMultiplier * 0.4,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.fiber_manual_record_rounded,
                      size: SizeConfig.widthMultiplier * 2,
                      color: AppColors.iconGrey,
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                    Expanded(
                      child: AppText(
                        '${item.name}  •  ${item.quantity}',
                        size: 11,
                        color: AppColors.textMedium,
                      ),
                    ),
                    AppText(
                      '${item.calories} kcal',
                      size: 10,
                      color: AppColors.iconGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
