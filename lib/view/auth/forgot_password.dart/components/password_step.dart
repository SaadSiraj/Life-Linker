import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:provider/provider.dart';

class ForgotPasswordNewPasswordStep extends StatelessWidget {
  final AnimationController animController;

  const ForgotPasswordNewPasswordStep({super.key, required this.animController});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacing.y(2),
            Container(
              width: SizeConfig.widthMultiplier * 16,
              height: SizeConfig.widthMultiplier * 16,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: SizeConfig.widthMultiplier * 8,
                color: AppColors.primary,
              ),
            ),
            Spacing.y(2.5),
            AppText(
              'New Password',
              size: 26,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            Spacing.y(1),
            AppText(
              'Create a strong password to keep\nyour account secure.',
              size: 14,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w400,
            ),
            Spacing.y(4.5),
            CustomTextField(
              controller: provider.newPasswordController,
              hint: 'New password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: provider.obscureNewPassword,
              suffixWidget: IconButton(
                icon: Icon(
                  provider.obscureNewPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.iconGrey,
                  size: SizeConfig.widthMultiplier * 5,
                ),
                onPressed: provider.toggleNewPasswordVisibility,
              ),
            ),
            Spacing.y(2),
            CustomTextField(
              controller: provider.confirmPasswordController,
              hint: 'Confirm new password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: provider.obscureConfirmPassword,
              suffixWidget: IconButton(
                icon: Icon(
                  provider.obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.iconGrey,
                  size: SizeConfig.widthMultiplier * 5,
                ),
                onPressed: provider.toggleConfirmPasswordVisibility,
              ),
            ),
            Spacing.y(4),
            CustomButton(
              text: 'Reset Password',
              isLoading: provider.isLoading,
              onTap: () =>
                  provider.handleResetPassword(context, animController),
            ),
            Spacing.y(3),
          ],
        );
      },
    );
  }
}