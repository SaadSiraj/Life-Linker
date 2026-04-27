import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class SettingsPlaceholderView extends StatelessWidget {
  const SettingsPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: SizeConfig.widthMultiplier * 20,
              height: SizeConfig.widthMultiplier * 20,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.settings_outlined,
                color: AppColors.primary,
                size: SizeConfig.widthMultiplier * 10,
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            AppText(
              'Settings',
              size: 20,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            AppText('Coming soon', size: 13, color: AppColors.iconGrey),
          ],
        ),
      ),
    );
  }
}
