import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/login.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.h),
            child: Column(
              children: [
                Gap.v(50),
                _buildLogo(),
                Gap.v(16),
                AppText(
                  'LifeLinker',
                  size: 30,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
                Gap.v(6),
                AppText(
                  'Welcome back — sign in to continue',
                  size: 13,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w400,
                ),
                Gap.v(40),
                _buildForm(),
                Gap.v(28),
                _buildSignupRow(context),
                Gap.v(24),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Image.asset(
        AppImages.building,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 110.h,
      height: 110.h,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          AppImages.logo,
          width: 75.h,
          height: 75.h,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.health_and_safety_rounded,
            size: 60.h,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) => Column(
        children: [
          // Email field
          CustomTextField(
            controller: provider.emailController,
            hint: 'Email address',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          Gap.v(14),

          // Password field
          CustomTextField(
            controller: provider.passwordController,
            hint: 'Password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: provider.obscurePassword,
            suffixWidget: IconButton(
              icon: Icon(
                provider.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.iconGrey,
                size: 20.h,
              ),
              onPressed: provider.togglePasswordVisibility,
            ),
          ),
          Gap.v(10),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, RouteNames.forgotPassword),
              child: AppText(
                'Forgot password?',
                size: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Gap.v(28),

          // Login button
          CustomButton(
            text: 'Sign In',
            isLoading: provider.isLoading,
            prefixIcon: provider.isLoading
                ? null
                : Icon(Icons.login_rounded, color: Colors.white, size: 18.h),
            onTap: () => provider.handleLogin(context, () {
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
          ),
          Gap.v(14),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.border)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                child: AppText('or', size: 12, color: AppColors.iconGrey),
              ),
              const Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          Gap.v(14),

          // Signup button
          CustomButton(
            text: 'Create New Account',
            isBordered: true,
            prefixIcon: Icon(
              Icons.person_add_outlined,
              color: AppColors.textDark,
              size: 18.h,
            ),
            onTap: () => Navigator.pushNamed(context, RouteNames.roleSelection),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText('New to LifeLinker? ', size: 13, color: AppColors.iconGrey),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RouteNames.roleSelection),
          child: AppText(
            'Sign Up',
            size: 13,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
