import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';

class ForgotPasswordSuccessStep extends StatelessWidget {
  const ForgotPasswordSuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacing.y(7.5),
        Container(
          width: SizeConfig.widthMultiplier * 30,
          height: SizeConfig.widthMultiplier * 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_outline_rounded,
            size: SizeConfig.widthMultiplier * 16,
            color: AppColors.primary,
          ),
        ),
        Spacing.y(3.5),
        AppText(
          'All Done!',
          size: 28,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        Spacing.y(1.5),
        AppText(
          'Your password has been reset\nsuccessfully.',
          size: 14,
          color: AppColors.iconGrey,
          fontWeight: FontWeight.w400,
          align: TextAlign.center,
        ),
        Spacing.y(6),
        CustomButton(
          text: 'Back to Login',
          onTap: () => Navigator.pop(context),
        ),
        Spacing.y(3),
      ],
    );
  }
}