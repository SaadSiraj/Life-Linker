import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class LocationMapSection extends StatelessWidget {
  const LocationMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        SizeConfig.widthMultiplier * 4,
        SizeConfig.heightMultiplier * 1.8,
        SizeConfig.widthMultiplier * 4,
        0,
      ),
      height: SizeConfig.heightMultiplier * 25,
      decoration: BoxDecoration(
        color: AppColors.mapBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Map grid background
            CustomPaint(
              size: Size(double.infinity, SizeConfig.heightMultiplier * 25),
              painter: _MapGridPainter(),
            ),

            // Safe zone circle
            Center(
              child: Container(
                width: SizeConfig.widthMultiplier * 24,
                height: SizeConfig.widthMultiplier * 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.4),
                    width: 2,
                  ),
                ),
              ),
            ),

            // Patient marker
            Positioned(
              top: SizeConfig.heightMultiplier * 9,
              left: SizeConfig.widthMultiplier * 32,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier * 1.5),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_pin_rounded,
                      color: Colors.white,
                      size: SizeConfig.widthMultiplier * 4.5,
                    ),
                  ),
                  Container(
                    width: 2,
                    height: SizeConfig.heightMultiplier * 1,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            // Live tracking label
            Positioned(
              bottom: SizeConfig.heightMultiplier * 1.2,
              right: SizeConfig.widthMultiplier * 2.5,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 2.5,
                  vertical: SizeConfig.heightMultiplier * 0.6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: AppColors.shadow, blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                      size: SizeConfig.widthMultiplier * 3.5,
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 1),
                    AppText(
                      'Live Tracking',
                      size: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),

            // Zoom controls
            Positioned(
              top: SizeConfig.heightMultiplier * 1.2,
              right: SizeConfig.widthMultiplier * 2.5,
              child: Column(
                children: [
                  _MapControlButton(icon: Icons.add, onTap: () {}),
                  SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                  _MapControlButton(icon: Icons.remove, onTap: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.widthMultiplier * 7.5,
        height: SizeConfig.widthMultiplier * 7.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
        ),
        child: Icon(
          icon,
          size: SizeConfig.widthMultiplier * 4,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.mapGrid
      ..strokeWidth = 0.8;

    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.35, 0),
      Offset(size.width * 0.35, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0),
      Offset(size.width * 0.7, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
