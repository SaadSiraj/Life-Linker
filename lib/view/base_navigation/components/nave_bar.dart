import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/base_navigation.dart';
import 'package:provider/provider.dart';

class BaseNavBar extends StatelessWidget {
  const BaseNavBar({super.key});

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
            children: [
              _NavItem(
                index: 0,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: 'Home',
              ),
              _NavItem(
                index: 1,
                icon: Icons.location_on_outlined,
                activeIcon: Icons.location_on_rounded,
                label: 'Location',
              ),
              const _CenterNavItem(),
              _NavItem(
                index: 3,
                icon: Icons.people_outline_rounded,
                activeIcon: Icons.people_rounded,
                label: 'Circle',
              ),
              _NavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BaseNavProvider>();
    final isActive = provider.currentIndex == index;

    return GestureDetector(
      onTap: () => provider.setIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3,
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? AppColors.primary : AppColors.iconGrey,
                size: isActive
                    ? SizeConfig.widthMultiplier * 6.5
                    : SizeConfig.widthMultiplier * 5.5,
              ),
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.5),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isActive
                    ? SizeConfig.textMultiplier * 1.4
                    : SizeConfig.textMultiplier * 1.3,
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
}

class _CenterNavItem extends StatelessWidget {
  const _CenterNavItem();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BaseNavProvider>();
    final isActive = provider.currentIndex == 2;

    return GestureDetector(
      onTap: () => provider.setIndex(2),
      child: Container(
        width: SizeConfig.widthMultiplier * 14,
        height: SizeConfig.widthMultiplier * 14,
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 2,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
          isActive ? Icons.medication_rounded : Icons.medication_outlined,
          color: Colors.white,
          size: SizeConfig.widthMultiplier * 7,
        ),
      ),
    );
  }
}
