import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.5,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: SizeConfig.widthMultiplier * 4.5,
            color: AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  size: 11,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                AppText(
                  value,
                  size: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}