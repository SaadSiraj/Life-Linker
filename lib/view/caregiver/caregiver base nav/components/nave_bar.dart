import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/caregiver_base_nav.dart';
import 'package:provider/provider.dart';

class CaregiverNavBar extends StatelessWidget {
  const CaregiverNavBar({super.key});

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
              // _CgNavItem(
              //   index: 0,
              //   icon: Icons.dashboard_outlined,
              //   activeIcon: Icons.dashboard_rounded,
              //   label: 'Home',
              // ),
              _CgNavItem(
                index: 0,
                icon: Icons.supervised_user_circle_outlined,
                activeIcon: Icons.people_rounded,
                label: 'Patients',
              ),
              _CgNavItem(
                index: 1,
                icon: Icons.location_on_outlined,
                activeIcon: Icons.location_on_rounded,
                label: 'Location',
              ),

              // const _CenterNavItem(),
              _CgNavItem(
                index: 2,
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

class _CgNavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _CgNavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CareGiverBaseNavProvider>();
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

// class _CenterNavItem extends StatelessWidget {
//   const _CenterNavItem();

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<CareGiverBaseNavProvider>();
//     // Center button is active when navIndex is 2 or 3 (both show Patients)
//     final isActive = provider.currentIndex == 2 || provider.currentIndex == 3;

//     return GestureDetector(
//       onTap: () => provider.setIndex(2),
//       child: Container(
//         width: SizeConfig.widthMultiplier * 14,
//         height: SizeConfig.widthMultiplier * 14,
//         margin: EdgeInsets.symmetric(
//           horizontal: SizeConfig.widthMultiplier * 2,
//         ),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: isActive
//                 ? [AppColors.primaryDark, AppColors.primary]
//                 : [AppColors.primary, AppColors.primary.withOpacity(0.8)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primary.withOpacity(isActive ? 0.5 : 0.3),
//               blurRadius: isActive ? 16 : 12,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Icon(
//           isActive ? Icons.people_rounded : Icons.people_outline_rounded,
//           color: Colors.white,
//           size: SizeConfig.widthMultiplier * 7,
//         ),
//       ),
//     );
//   }
// }
