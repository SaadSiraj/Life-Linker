import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/forgot_password.dart';
import 'package:lifelinker/view/common/login/forgot_password.dart/components/email_step.dart';
import 'package:lifelinker/view/common/login/forgot_password.dart/components/otp_step.dart';
import 'package:lifelinker/view/common/login/forgot_password.dart/components/password_step.dart';
import 'package:lifelinker/view/common/login/forgot_password.dart/components/success_step.dart';
import 'package:provider/provider.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Consumer<ForgotPasswordProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: provider.currentStep == ForgotPasswordStep.success
                ? null
                : _BackButton(
                    provider: provider,
                    animController: _animController,
                  ),
          ),
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthMultiplier * 7,
                    ),
                    child: _buildCurrentStep(
                      context,
                      provider,
                      _animController,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    ForgotPasswordProvider provider,
    AnimationController animController,
  ) {
    switch (provider.currentStep) {
      case ForgotPasswordStep.email:
        return ForgotPasswordEmailStep(animController: animController);
      case ForgotPasswordStep.otp:
        return ForgotPasswordOtpStep(animController: animController);
      case ForgotPasswordStep.newPassword:
        return ForgotPasswordNewPasswordStep(animController: animController);
      case ForgotPasswordStep.success:
        return const ForgotPasswordSuccessStep();
    }
  }
}

class _BackButton extends StatelessWidget {
  final ForgotPasswordProvider provider;
  final AnimationController animController;

  const _BackButton({required this.provider, required this.animController});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        width: SizeConfig.widthMultiplier * 9.5,
        height: SizeConfig.widthMultiplier * 9.5,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: SizeConfig.widthMultiplier * 4,
          color: AppColors.textDark,
        ),
      ),
      onPressed: () {
        if (provider.currentStep == ForgotPasswordStep.email) {
          Navigator.pop(context);
        } else if (provider.currentStep == ForgotPasswordStep.otp) {
          provider.transitionToStep(ForgotPasswordStep.email, animController);
        } else if (provider.currentStep == ForgotPasswordStep.newPassword) {
          provider.transitionToStep(ForgotPasswordStep.otp, animController);
        }
      },
    );
  }
}
