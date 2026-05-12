import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PatientInfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final IconData? icon;

  const PatientInfoChip({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2,
        vertical: SizeConfig.heightMultiplier * 0.35,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: SizeConfig.widthMultiplier * 2.8,
              color: textColor,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 1),
          ],
          AppText(
            label,
            size: 10,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
