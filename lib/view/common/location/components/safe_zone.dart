import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class LocationSafeZoneAlert extends StatelessWidget {
  final String patientName;

  const LocationSafeZoneAlert({super.key, required this.patientName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(
          SizeConfig.widthMultiplier * 4,
          SizeConfig.heightMultiplier * 1.5,
          SizeConfig.widthMultiplier * 4,
          0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3.5,
          vertical: SizeConfig.heightMultiplier * 1.5,
        ),
        decoration: BoxDecoration(
          color: AppColors.alert.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.alert.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppColors.alert,
              size: SizeConfig.widthMultiplier * 5,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 2),
            Expanded(
              child: AppText(
                '$patientName left the safe zone!',
                size: 13,
                color: AppColors.alert,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.alert,
              size: SizeConfig.widthMultiplier * 5,
            ),
          ],
        ),
      ),
    );
  }
}
