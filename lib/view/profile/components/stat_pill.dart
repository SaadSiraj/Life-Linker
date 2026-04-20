import 'package:flutter/material.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class ProfileStatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const ProfileStatPill({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3,
        vertical: SizeConfig.heightMultiplier * 0.8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: SizeConfig.widthMultiplier * 3.2, color: color),
          SizedBox(width: SizeConfig.widthMultiplier * 1.2),
          AppText(label, size: 11, color: color, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}