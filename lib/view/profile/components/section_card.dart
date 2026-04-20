import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.widthMultiplier * 4,
              SizeConfig.heightMultiplier * 2,
              SizeConfig.widthMultiplier * 4,
              0,
            ),
            child: Row(
              children: [
                Container(
                  width: SizeConfig.widthMultiplier * 8.5,
                  height: SizeConfig.widthMultiplier * 8.5,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: SizeConfig.widthMultiplier * 4.5,
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 2.5),
                AppText(
                  title,
                  size: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 4,
            ),
            child: Column(children: children),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 0.5),
        ],
      ),
    );
  }
}