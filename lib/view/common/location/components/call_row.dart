import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class LocationNavigateCallRow extends StatelessWidget {
  const LocationNavigateCallRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.widthMultiplier * 4,
        SizeConfig.heightMultiplier * 1.5,
        SizeConfig.widthMultiplier * 4,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: _OutlineButton(
              label: 'Navigate',
              icon: Icons.navigation_rounded,
              onTap: () {},
            ),
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          Expanded(
            child: _OutlineButton(
              label: 'Call',
              icon: Icons.phone_rounded,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 1.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 4.5,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 1.5),
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
}