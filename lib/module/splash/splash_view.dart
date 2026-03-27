import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_images.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/core/utils/size_utils.dart';

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

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    });
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
            colors: [
              Color(0xFF4DA3FF), // light blue top
              Color(0xFF2A7FFF), // primary mid
              Color(0xFF1A5FCC), // deeper blue bottom
            ],
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
              Image.asset(AppImages.logo,
              width: 190.h,
              height: 190.h,
              ),


                // App Name
                AppText(
                  'LifeLinker',
                  size: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),

                Gap.v(10),

                // Tagline
                AppText(
                  'Caring Through Memory',
                  size: 15,
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 160.h,
      height: 160.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Head silhouette base
          _buildHeadSilhouette(),

          // Puzzle piece top-right
          Positioned(
            top: 14.h,
            right: 14.h,
            child: _buildPuzzlePiece(),
          ),

          // Shield bottom-left
          Positioned(
            bottom: 20.h,
            left: 20.h,
            child: _buildShield(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadSilhouette() {
    return SizedBox(
      width: 110.h,
      height: 110.h,
      child: CustomPaint(
        painter: _HeadBrainPainter(),
      ),
    );
  }

  Widget _buildPuzzlePiece() {
    return Icon(
      Icons.extension,
      color: Colors.white.withOpacity(0.9),
      size: 28.h,
    );
  }

  Widget _buildShield() {
    return Container(
      width: 28.h,
      height: 28.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.shield_outlined,
        color: Colors.white,
        size: 20.h,
      ),
    );
  }
}

/// Custom painter for head + brain + magnifier illustration
class _HeadBrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Head shape
    final headPath = Path();
    headPath.moveTo(cx - 20, cy + 40);
    headPath.lineTo(cx - 28, cy + 20);
    headPath.quadraticBezierTo(cx - 40, cy - 10, cx - 30, cy - 30);
    headPath.quadraticBezierTo(cx - 15, cy - 50, cx, cy - 48);
    headPath.quadraticBezierTo(cx + 25, cy - 48, cx + 32, cy - 25);
    headPath.quadraticBezierTo(cx + 40, cy, cx + 28, cy + 20);
    headPath.lineTo(cx + 20, cy + 40);
    headPath.close();

    canvas.drawPath(headPath, paint);
    canvas.drawPath(headPath, strokePaint);

    // Brain (simplified circular blobs)
    final brainPaint = Paint()
      ..color = Colors.white.withOpacity(0.0)
      ..style = PaintingStyle.fill;
    final brainStroke = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    // Left brain lobe
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - 8, cy - 8),
        width: 28,
        height: 22,
      ),
      brainStroke,
    );
    // Right brain lobe
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + 8, cy - 8),
        width: 24,
        height: 20,
      ),
      brainStroke,
    );
    // Center divider line
    canvas.drawLine(
      Offset(cx, cy - 18),
      Offset(cx, cy + 2),
      brainStroke,
    );

    // Magnifier glass
    final magCenter = Offset(cx - 5, cy + 5);
    final magRadius = 14.0;

    canvas.drawCircle(magCenter, magRadius, brainPaint);
    canvas.drawCircle(magCenter, magRadius, strokePaint);

    // Magnifier handle
    canvas.drawLine(
      Offset(magCenter.dx + 10, magCenter.dy + 10),
      Offset(magCenter.dx + 18, magCenter.dy + 18),
      strokePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}