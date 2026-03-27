import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/module/dashboard/dashboard_view.dart';
import 'package:lifelinker/module/location/location_view.dart';
import 'package:lifelinker/module/medication/medication.dart';
import 'package:lifelinker/module/people_list/people_list_view.dart';
import 'package:lifelinker/module/profile/profile_view.dart';

class BaseNavigationView extends StatefulWidget {
  const BaseNavigationView({super.key});

  @override
  State<BaseNavigationView> createState() => _BaseNavigationViewState();
}

class _BaseNavigationViewState extends State<BaseNavigationView> {
  int _currentIndex = 0;
  DateTime? _lastPressed;

  final List<Widget> _screens = const [
    DashboardView(),
    LocationView(),
    MedicationView(),
    PeopleListView(),
    ProfileView(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Location',
    'Medication',
    'People',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        await _onWillPop();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
         
            Expanded(
              child: _screens[_currentIndex],
            ),
          ],
        ),
        bottomNavigationBar: _buildModernNavBar(),
      ),
    );
  }

 

  Widget _buildModernNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 78.v,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard_rounded, 'Home'),
              _buildNavItem(1, Icons.location_on_outlined, Icons.location_on_rounded, 'Location'),
              _buildCenterNavItem(),
              _buildNavItem(3, Icons.people_outline_rounded, Icons.people_rounded, 'Circle'),
              _buildNavItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 56.h,
        height: 56.h,
        margin: EdgeInsets.symmetric(horizontal: 8.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _currentIndex == 2 ? Icons.medication_rounded : Icons.medication_outlined,
          color: Colors.white,
          size: 28.h,
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => _currentIndex = index);
        _animateNavItem(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 12.h,
          vertical: 8.v,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.iconGrey,
                size: isActive ? 26.h : 22.h,
              ),
            ),
            SizedBox(height: 4.v),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isActive ? 11.fSize : 10.fSize,
                fontFamily: 'Poppins',
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.iconGrey,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  void _animateNavItem(int index) {
    // Haptic feedback for better UX
    // Uncomment if you want haptic feedback
    // HapticFeedback.lightImpact();
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;
      _showExitSnackBar();
      return false;
    }
    return _showExitDialog();
  }

  void _showExitSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primary,
              size: 20,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: AppText(
                'Press back again to exit',
                size: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.textDark,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16.h),
      ),
    );
  }

  Future<bool> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: EdgeInsets.all(24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: AppColors.alert.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.exit_to_app_rounded,
                  color: AppColors.alert,
                  size: 48.h,
                ),
              ),
              Gap.v(20),
              // Title
              AppText(
                'Exit LifeLinker',
                size: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              Gap.v(12),
              // Message
              AppText(
                'Are you sure you want to exit the app?',
                size: 14,
                color: AppColors.iconGrey,
                align: TextAlign.center,
              ),
              Gap.v(24),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.v),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.border),
                        ),
                      ),
                      child: AppText(
                        'Cancel',
                        size: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.iconGrey,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.alert,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.v),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: AppText(
                        'Exit',
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldExit == true) {
      // Close the app
      return true;
    }
    return false;
  }
}