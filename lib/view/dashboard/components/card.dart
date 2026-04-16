import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class DashCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const DashCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.h,
              height: 42.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22.h),
            ),
            const Spacer(),
            AppText(
              title,
              size: 11,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
            SizedBox(height: 3.v),
            AppText(
              value,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ),
            SizedBox(height: 2.v),
            AppText(
              subtitle,
              size: 11,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w400,
              maxLines: 1,
            ),
            SizedBox(height: 6.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12.h,
                  color: AppColors.iconGrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}