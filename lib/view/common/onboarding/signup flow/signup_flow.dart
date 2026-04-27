import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/components/step_basic_info.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/components/step_credentials.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/components/step_profile_image.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/components/step_role_data.dart';
import 'package:provider/provider.dart';

class SignupFlowView extends StatefulWidget {
  const SignupFlowView({super.key});

  @override
  State<SignupFlowView> createState() => _SignupFlowViewState();
}

class _SignupFlowViewState extends State<SignupFlowView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _animateToStep() {
    _animController.reverse().then((_) {
      _animController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return PopScope(
          canPop: provider.isFirstStep,
          onPopInvoked: (didPop) {
            if (!didPop && !provider.isFirstStep) {
              provider.previousStep();
              _animateToStep();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: _buildAppBar(context, provider),
            body: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.h),
                      child: Column(
                        children: [
                          Gap.v(8),
                          _buildProgressIndicator(provider),
                          Gap.v(28),
                          _buildCurrentStep(context, provider),
                          Gap.v(24),
                          _buildBottomButtons(context, provider),
                          Gap.v(32),
                        ],
                      ),
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

  AppBar _buildAppBar(BuildContext context, SignupProvider provider) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          if (provider.isFirstStep) {
            Navigator.pop(context);
          } else {
            provider.previousStep();
            _animateToStep();
          }
        },
        icon: Container(
          width: 38.h,
          height: 38.h,
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
            size: 16.h,
            color: AppColors.textDark,
          ),
        ),
      ),
      title: AppText(
        'Create Account',
        size: 17,
        color: AppColors.textDark,
        fontWeight: FontWeight.w700,
      ),
      centerTitle: true,
    );
  }

  Widget _buildProgressIndicator(SignupProvider provider) {
    final stepTitles = ['Basic Info', 'Your Details', 'Photo', 'Account'];
    return Column(
      children: [
        Row(
          children: List.generate(provider.totalSteps, (i) {
            final isActive = i <= provider.currentStepIndex;
            final isCurrent = i == provider.currentStepIndex;
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isCurrent ? 6.0 : 4.0,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (i < provider.totalSteps - 1) Gap.h(6),
                ],
              ),
            );
          }),
        ),
        Gap.v(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(provider.totalSteps, (i) {
            final isActive = i <= provider.currentStepIndex;
            return AppText(
              stepTitles[i],
              size: 10,
              color: isActive ? AppColors.primary : AppColors.iconGrey,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCurrentStep(BuildContext context, SignupProvider provider) {
    switch (provider.currentStep) {
      case SignupStep.basicInfo:
        return const StepBasicInfo();
      case SignupStep.roleData:
        return const StepRoleData();
      case SignupStep.profileImage:
        return const StepProfileImage();
      case SignupStep.credentials:
        return const StepCredentials();
    }
  }

  Widget _buildBottomButtons(BuildContext context, SignupProvider provider) {
    if (provider.isLastStep) {
      return CustomButton(
        text: 'Create Account',
        isLoading: provider.isLoading,
        prefixIcon: provider.isLoading
            ? null
            : Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
                size: 18.h,
              ),
        onTap: () => provider.signup(context, () {
          final role = SharedPrefsService.getUserRole();
          if (role == 'caregiver') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.caregiverBase,
              (_) => false,
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.patientBase,
              (_) => false,
            );
          }
        }),
      );
    }

    return Column(
      children: [
        CustomButton(
          text: provider.currentStep == SignupStep.profileImage
              ? (provider.profileImage != null ? 'Continue' : 'Skip for now')
              : 'Continue',
          onTap: () {
            provider.nextStep(context);
            _animateToStep();
          },
          suffixIcon: Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 18.h,
          ),
        ),
      ],
    );
  }
}
