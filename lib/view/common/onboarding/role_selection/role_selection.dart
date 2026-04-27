import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:provider/provider.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  Gap.v(30),
                  _buildHeader(),
                  const Spacer(),
                  _buildRoleCards(),
                  Gap.v(24),
                  _buildLoginLink(),
                  Gap.v(32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset(
          AppImages.logo,
          width: 90.h,
          height: 90.h,
          errorBuilder: (_, _, _) => Icon(
            Icons.health_and_safety_rounded,
            size: 80.h,
            color: Colors.white,
          ),
        ),
        Gap.v(16),
        AppText(
          'LifeLinker',
          size: 30,
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        Gap.v(6),
        AppText(
          'Who are you?',
          size: 16,
          color: Colors.white.withOpacity(0.85),
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildRoleCards() {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            children: [
              _RoleCard(
                icon: Icons.elderly_rounded,
                title: 'Patient',
                subtitle: 'I need care and monitoring assistance',
                isSelected: provider.role == UserRole.patient,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFF9B8BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => provider.setRole(UserRole.patient),
              ),
              Gap.v(16),
              _RoleCard(
                icon: Icons.volunteer_activism_rounded,
                title: 'Caregiver',
                subtitle: 'I monitor and take care of a patient',
                isSelected: provider.role == UserRole.caregiver,
                gradient: const LinearGradient(
                  colors: [Color(0xFF34C759), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () => provider.setRole(UserRole.caregiver),
              ),
              Gap.v(32),
              CustomButton(
                text: 'Continue as ${provider.role == UserRole.patient ? 'Patient' : 'Caregiver'}',
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.signup);
                },
                backgroundColor: Colors.white,
                textColor: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          'Already have an account? ',
          size: 14,
          color: Colors.white.withOpacity(0.8),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RouteNames.login),
          child: AppText(
            'Sign In',
            size: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ─── Role Selection Card ───────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 58.h,
              height: 58.h,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28.h),
            ),
            Gap.h(16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    size: 18,
                    color: isSelected ? AppColors.textDark : Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  Gap.v(4),
                  AppText(
                    subtitle,
                    size: 12,
                    color: isSelected
                        ? AppColors.iconGrey
                        : Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            // Check badge
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24.h,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 14.h)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}