import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class LocationQuickActions extends StatelessWidget {
  const LocationQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 4,
      ),
      child: Row(
        children: [
          _ActionChip(
            icon: Icons.location_on_rounded,
            label: 'Location',
            isActive: true,
            onTap: () {},
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2.5),
          _ActionChip(
            icon: Icons.route_rounded,
            label: 'Route',
            onTap: () {},
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2.5),
          _ActionChip(
            icon: Icons.medication_rounded,
            label: 'Medication',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 1.5,
          ),
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
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 6,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.primary : AppColors.iconGrey,
                size: SizeConfig.widthMultiplier * 5.5,
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 0.7),
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
}