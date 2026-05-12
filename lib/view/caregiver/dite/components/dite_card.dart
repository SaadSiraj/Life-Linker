import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dite_plan.dart';
import 'package:lifelinker/view/caregiver/dite/components/dite_action_btn.dart';
import 'package:lifelinker/view/caregiver/dite/components/meal_type_chip.dart';

class CaregiverDietCard extends StatelessWidget {
  final DietPlanModel plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CaregiverDietCard({
    super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
  });

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
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 11,
                height: SizeConfig.widthMultiplier * 11,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.successDark,
                  size: SizeConfig.widthMultiplier * 6,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      plan.title,
                      size: 15,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    if (plan.description != null &&
                        plan.description!.isNotEmpty)
                      AppText(
                        plan.description!,
                        size: 12,
                        color: AppColors.iconGrey,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
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
                  '${plan.totalDailyCalories} kcal',
                  size: 11,
                  color: AppColors.successDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (plan.meals.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            Divider(color: AppColors.divider, height: 1),
            SizedBox(height: SizeConfig.heightMultiplier * 1.2),
            Wrap(
              spacing: SizeConfig.widthMultiplier * 2,
              runSpacing: SizeConfig.heightMultiplier * 0.8,
              children: plan.meals.map((m) => MealTypeChip(meal: m)).toList(),
            ),
          ],
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DietActionBtn(
                icon: Icons.edit_rounded,
                label: 'Edit',
                color: AppColors.primary,
                onTap: onEdit,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              DietActionBtn(
                icon: Icons.delete_outline_rounded,
                label: 'Remove',
                color: AppColors.alert,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
