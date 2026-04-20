import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PerspnsListHeader extends StatelessWidget {
  const PerspnsListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.widthMultiplier * 5,
            SizeConfig.heightMultiplier * 1.5,
            SizeConfig.widthMultiplier * 5,
            SizeConfig.heightMultiplier * 3,
          ),
          child: Row(
            children: [
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              AppText(
                'Known People',
                size: 18,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
