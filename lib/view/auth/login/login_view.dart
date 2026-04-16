import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/login.dart';
import 'package:lifelinker/view/base_navigation/base_navigation_view.dart';
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
                Gap.v(60),
                _buildLogo(),
                Gap.v(20),
                AppText(
                  'LifeLinker',
                  size: 32,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
                Gap.v(8),
                AppText(
                  'Your health companion',
                  size: 14,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w400,
                ),
                Gap.v(40),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Image.asset(AppImages.building),
    );
  }

  Widget _buildLogo() {
    return Consumer<LoginProvider>(
      builder: (_, _, _) => Container(
        width: 140.h,
        height: 140.h,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            AppImages.logo,
            width: 100.h,
            height: 100.h,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Icon(
              Icons.health_and_safety,
              size: 70.h,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) => Column(
        children: [
          CustomTextField(
            controller: provider.emailController,
            hint: 'Email',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          Gap.v(16),
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
          Gap.v(12),
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
          Gap.v(32),
          CustomButton(
            text: 'Login',
            isLoading: provider.isLoading,
            onTap: () => provider.handleLogin(
              context,
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BaseNavigationView()),
              ),
            ),
          ),
          Gap.v(24),
        ],
      ),
    );
  }
}
