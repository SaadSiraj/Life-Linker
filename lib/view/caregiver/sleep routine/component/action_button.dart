import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class SleepActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const SleepActionBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3,
          vertical: SizeConfig.heightMultiplier * 0.7,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: SizeConfig.widthMultiplier * 3.5, color: color),
            SizedBox(width: SizeConfig.widthMultiplier * 1),
            AppText(
              label,
              size: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}