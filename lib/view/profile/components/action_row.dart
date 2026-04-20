import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class ActionRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionRow({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 1.6,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: SizeConfig.widthMultiplier * 5,
              color: color,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 3),
            Expanded(
              child: AppText(
                label,
                size: 13,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: SizeConfig.widthMultiplier * 4.5,
              color: AppColors.iconGrey,
            ),
          ],
        ),
      ),
    );
  }
}