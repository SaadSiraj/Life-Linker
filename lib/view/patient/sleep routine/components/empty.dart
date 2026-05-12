import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PatientSleepEmpty extends StatelessWidget {
  const PatientSleepEmpty({super.key});

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
              color: AppColors.medicationViolet.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bedtime_rounded,
              color: AppColors.medicationViolet,
              size: SizeConfig.widthMultiplier * 12,
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2.5),
          AppText(
            'No Sleep Routine Yet',
            size: 17,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText(
            'Your caregiver will assign a\nsleep routine for you here.',
            size: 13,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}