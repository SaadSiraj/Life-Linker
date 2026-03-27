import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/core/utils/size_utils.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  // Mock patient data
  final String patientName = 'John Doe';
  final String patientStatus = 'SAFE';
  final String lastSeen = '0 min ago';
  final bool isInSafeZone = false; // false = left safe zone alert

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPatientCard(),
                  _buildQuickActions(),
                  if (!isInSafeZone) _buildSafeZoneAlert(),
                  _buildNavigateCallRow(),
                  _buildMapSection(),
                  _buildActivityHealth(),
                  SizedBox(height: 24.v),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4DA3FF), Color(0xFF2A7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
          child: Row(
            children: [
             
              SizedBox(width: 8.h),
              Expanded(
                child: AppText(
                  'Patient Location',
                  size: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  align: TextAlign.center,
                ),
              ),
              Icon(Icons.my_location_rounded,
                  color: Colors.white, size: 22.h),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Patient Card ──────────────────────────────────────────────────────────

  Widget _buildPatientCard() {
    return Container(
      margin: EdgeInsets.all(16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 28.h,
                backgroundColor: AppColors.border,
                child: Icon(Icons.person_rounded,
                    size: 32.h, color: AppColors.iconGrey),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14.h,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 12.h),

          // Name & status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(patientName,
                    size: 16,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600),
                SizedBox(height: 4.v),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.h, vertical: 2.v),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AppText(
                        patientStatus,
                        size: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.h),
                    AppText(lastSeen,
                        size: 12, color: AppColors.iconGrey),
                  ],
                ),
              ],
            ),
          ),

          Icon(Icons.chevron_right_rounded,
              color: AppColors.iconGrey, size: 22.h),
        ],
      ),
    );
  }

  // ─── Quick Actions ─────────────────────────────────────────────────────────

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          _buildActionChip(
            icon: Icons.location_on_rounded,
            label: 'Location',
            isActive: true,
            onTap: () {},
          ),
          SizedBox(width: 10.h),
          _buildActionChip(
            icon: Icons.route_rounded,
            label: 'Route',
            onTap: () {},
          ),
          SizedBox(width: 10.h),
          _buildActionChip(
            icon: Icons.medication_rounded,
            label: 'Medication',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.v),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? AppColors.primary.withOpacity(0.3)
                  : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 6,
                  offset: const Offset(0, 1)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon,
                  color:
                      isActive ? AppColors.primary : AppColors.iconGrey,
                  size: 22.h),
              SizedBox(height: 6.v),
              AppText(
                label,
                size: 11,
                color: isActive ? AppColors.primary : AppColors.textDark,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Safe Zone Alert ───────────────────────────────────────────────────────

  Widget _buildSafeZoneAlert() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.fromLTRB(16.h, 12.v, 16.h, 0),
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.v),
        decoration: BoxDecoration(
          color: AppColors.alert.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.alert.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: AppColors.alert, size: 20.h),
            SizedBox(width: 8.h),
            Expanded(
              child: AppText(
                'John left the safe zone!',
                size: 13,
                color: AppColors.alert,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.alert, size: 20.h),
          ],
        ),
      ),
    );
  }

  // ─── Navigate & Call ───────────────────────────────────────────────────────

  Widget _buildNavigateCallRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 12.v, 16.h, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildOutlineButton(
              label: 'Navigate',
              icon: Icons.navigation_rounded,
              onTap: () {},
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: _buildOutlineButton(
              label: 'Call',
              icon: Icons.phone_rounded,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.v),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 1)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 18.h),
            SizedBox(width: 6.h),
            AppText(
              label,
              size: 14,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Map Section ───────────────────────────────────────────────────────────

  Widget _buildMapSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 14.v, 16.h, 0),
      height: 200.v,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Map placeholder grid
            CustomPaint(
              size: Size(double.infinity, 200.v),
              painter: _MapGridPainter(),
            ),

            // Safe zone circle
            Center(
              child: Container(
                width: 100.h,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.1),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.4),
                      width: 2),
                ),
              ),
            ),

            // Patient marker
            Positioned(
              top: 70.v,
              left: 130.h,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Icon(Icons.person_pin_rounded,
                        color: Colors.white, size: 18.h),
                  ),
                  Container(
                    width: 2,
                    height: 8.v,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),

            // Map label
            Positioned(
              bottom: 10.v,
              right: 10.h,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadow, blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: AppColors.primary, size: 14.h),
                    SizedBox(width: 4.h),
                    AppText('Live Tracking',
                        size: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500),
                  ],
                ),
              ),
            ),

            // Zoom controls
            Positioned(
              top: 10.v,
              right: 10.h,
              child: Column(
                children: [
                  _buildMapControl(Icons.add, () {}),
                  SizedBox(height: 4.v),
                  _buildMapControl(Icons.remove, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControl(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.h,
        height: 30.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 4),
          ],
        ),
        child: Icon(icon, size: 16.h, color: AppColors.textDark),
      ),
    );
  }

  // ─── Activity & Health ─────────────────────────────────────────────────────

  Widget _buildActivityHealth() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.h, 14.v, 16.h, 0),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Activity & Health',
              size: 15,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600),
          SizedBox(height: 14.v),
          Row(
            children: [
              _buildStatCard(
                icon: Icons.directions_walk_rounded,
                iconColor: AppColors.primary,
                value: '1,482',
                unit: 'Steps',
              ),
              SizedBox(width: 10.h),
              _buildStatCard(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.alert,
                value: '76',
                unit: 'BPM',
              ),
              SizedBox(width: 10.h),
              _buildStatCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.pending,
                value: '320',
                unit: 'Cal',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.v),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22.h),
            SizedBox(height: 6.v),
            AppText(value,
                size: 15,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700),
            SizedBox(height: 2.v),
            AppText(unit,
                size: 11,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w400),
          ],
        ),
      ),
    );
  }
}

// ─── Map Grid Painter ──────────────────────────────────────────────────────

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0DFF5)
      ..strokeWidth = 0.8;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Road-like paths
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.35, 0),
        Offset(size.width * 0.35, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height),
        roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}