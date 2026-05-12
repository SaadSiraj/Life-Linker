import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class CaregiverMedEmpty extends StatelessWidget {
  const CaregiverMedEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 25,
            height: SizeConfig.widthMultiplier * 25,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_rounded,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 12,
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2.5),
          AppText(
            'No Medications Added',
            size: 17,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText(
            'Tap the button below to add\nthe first medication for this patient.',
            size: 13,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}