import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:provider/provider.dart';

class ForgotPasswordOtpStep extends StatelessWidget {
  final AnimationController animController;

  const ForgotPasswordOtpStep({super.key, required this.animController});

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
                Icons.verified_outlined,
                size: SizeConfig.widthMultiplier * 8,
                color: AppColors.primary,
              ),
            ),
            Spacing.y(2.5),
            AppText(
              'Check Your Email',
              size: 26,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
            Spacing.y(1),
            AppText.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.7,
                  fontFamily: 'Poppins',
                  color: AppColors.iconGrey,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'We sent a 4-digit code to\n'),
                  TextSpan(
                    text: provider.emailController.text.trim(),
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Spacing.y(4.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => AppOtpTextField(
                  controller: provider.otpControllers[index],
                  focusNode: provider.otpFocusNodes[index],
                  onChanged: (value) => provider.handleOtpChanged(value, index),
                ),
              ),
            ),
            Spacing.y(3.5),
            Center(
              child: provider.resendTimer > 0
                  ? AppText.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.6,
                          fontFamily: 'Poppins',
                          color: AppColors.iconGrey,
                        ),
                        children: [
                          const TextSpan(text: 'Resend code in '),
                          TextSpan(
                            text: '${provider.resendTimer}s',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: provider.resendOtp,
                      child: AppText.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.6,
                            fontFamily: 'Poppins',
                            color: AppColors.iconGrey,
                          ),
                          children: [
                            const TextSpan(text: "Didn't receive it? "),
                            const TextSpan(
                              text: 'Resend',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Spacing.y(4),
            CustomButton(
              text: 'Verify Code',
              isLoading: provider.isLoading,
              onTap: () => provider.handleVerifyOtp(context, animController),
            ),
            Spacing.y(3),
          ],
        );
      },
    );
  }
}
