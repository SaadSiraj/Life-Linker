import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/known_person.dart';

class RelationshipChip extends StatelessWidget {
  final PersonRelationship relationship;
  final bool isSelected;
  final VoidCallback onTap;

  const RelationshipChip({
    super.key,
    required this.relationship,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.v),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderLight,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(relationship.emoji, size: 15),
            SizedBox(width: 6.h),
            AppText(
              relationship.label,
              size: 12,
              color: isSelected ? Colors.white : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
