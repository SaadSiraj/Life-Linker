import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dite_plan.dart';

class MealFormTile extends StatelessWidget {
  final DietMeal meal;
  final VoidCallback onRemove;

  const MealFormTile({
    super.key,
    required this.meal,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1),
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      meal.typeLabel,
                      size: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    if (meal.time.isNotEmpty) ...[
                      SizedBox(width: SizeConfig.widthMultiplier * 2),
                      AppText(
                        meal.time,
                        size: 11,
                        color: AppColors.iconGrey,
                      ),
                    ],
                    const Spacer(),
                    AppText(
                      '${meal.totalCalories} kcal',
                      size: 11,
                      color: AppColors.successDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                ...meal.items.map(
                  (item) => AppText(
                    '• ${item.name}  ${item.quantity}',
                    size: 11,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.remove_circle_outline_rounded,
              color: AppColors.alert,
              size: SizeConfig.widthMultiplier * 5,
            ),
          ),
        ],
      ),
    );
  }
}