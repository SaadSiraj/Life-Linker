import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PerspnsListFab extends StatelessWidget {
  final VoidCallback onTap;

  const PerspnsListFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.heightMultiplier * 7,
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 5.5,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_add_rounded,
              color: Colors.white,
              size: SizeConfig.widthMultiplier * 5,
            ),
            Spacing.x(2),
            AppText(
              'Add Person',
              size: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}
