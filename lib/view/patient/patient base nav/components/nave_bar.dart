// ── nave_bar.dart (patient) ───────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/patient_base_nave.dart';
import 'package:provider/provider.dart';

class PatientNavBar extends StatelessWidget {
  const PatientNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: SizeConfig.heightMultiplier * 9.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _PatNavItem(
                index: 0,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Home',
              ),
              _PatNavItem(
                index: 1,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
              ),
              _PatNavItem(
                index: 2,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings_rounded,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _PatNavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PatientNavProvider>();
    final isActive = provider.currentIndex == index;

    return GestureDetector(
      onTap: () => provider.setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 5,
          vertical: SizeConfig.heightMultiplier * 1,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.iconGrey,
              size: isActive
                  ? SizeConfig.widthMultiplier * 6.5
                  : SizeConfig.widthMultiplier * 5.5,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.5),
            Text(
              label,
              style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 1.3,
                fontFamily: 'Poppins',
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.iconGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
