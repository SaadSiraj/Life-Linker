import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:provider/provider.dart';

class ForgotPasswordEmailStep extends StatelessWidget {
  final AnimationController animController;

  const ForgotPasswordEmailStep({super.key, required this.animController});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ForgotPasswordProvider>();

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
            Icons.lock_reset_rounded,
            size: SizeConfig.widthMultiplier * 8,
            color: AppColors.primary,
          ),
        ),
        Spacing.y(2.5),
        AppText(
          'Forgot Password?',
          size: 26,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        Spacing.y(1),
        AppText(
          'No worries! Enter your registered email\nand we\'ll send you a reset code.',
          size: 14,
          color: AppColors.iconGrey,
          fontWeight: FontWeight.w400,
        ),
        Spacing.y(4.5),
        CustomTextField(
          controller: provider.emailController,
          hint: 'Email address',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
        ),
        Spacing.y(4),
        Consumer<ForgotPasswordProvider>(
          builder: (context, prov, _) => CustomButton(
            text: 'Send Reset Code',
            isLoading: prov.isLoading,
            onTap: () => prov.handleSendOtp(context, animController),
          ),
        ),
        Spacing.y(3),
      ],
    );
  }
}