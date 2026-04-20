import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PerspnsListEmpty extends StatelessWidget {
  const PerspnsListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline_rounded,
            size: SizeConfig.widthMultiplier * 15,
            color: AppColors.iconGrey.withOpacity(0.4),
          ),
          Spacing.y(1.8),
          AppText(
            'No people found',
            size: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          Spacing.y(0.8),
          AppText(
            'Add familiar people so the patient recognises them.',
            size: 12,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
