import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PatientDietEmpty extends StatelessWidget {
  const PatientDietEmpty({super.key});

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
              color: AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.successDark,
              size: SizeConfig.widthMultiplier * 12,
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2.5),
          AppText(
            'No Diet Plan Yet',
            size: 17,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText(
            'Your caregiver will assign\na diet plan for you here.',
            size: 13,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}