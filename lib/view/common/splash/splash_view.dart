import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/repository/auth_repo.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      if (mounted) _navigate();
    });
  }

  Future<void> _navigate() async {
    final isLoggedIn = SharedPrefsService.getLoggedInStatus();
    final firebaseUser = AuthRepository.firebaseUser;
    final role = SharedPrefsService.getUserRole();

    if (isLoggedIn && firebaseUser != null && mounted) {
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
    } else {
      if (mounted) Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4DA3FF), Color(0xFF2A7FFF), Color(0xFF1A5FCC)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  AppImages.logo,
                  width: 180.h,
                  height: 180.h,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.health_and_safety_rounded,
                    size: 100.h,
                    color: Colors.white,
                  ),
                ),
                Gap.v(16),

                // App Name
                AppText(
                  'LifeLinker',
                  size: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
                Gap.v(8),

                // Tagline
                AppText(
                  'Caring Through Memory',
                  size: 15,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
                Gap.v(48),

                // Loading indicator
                SizedBox(
                  width: 24.h,
                  height: 24.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
