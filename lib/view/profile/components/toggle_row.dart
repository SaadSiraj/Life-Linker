import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeColor;

  const ToggleRow({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  size: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                AppText(
                  subtitle,
                  size: 11,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? AppColors.primary,
              activeTrackColor:
                  (activeColor ?? AppColors.primary).withOpacity(0.2),
              inactiveThumbColor: AppColors.grey400,
              inactiveTrackColor: AppColors.grey200,
            ),
          ),
        ],
      ),
    );
  }
}