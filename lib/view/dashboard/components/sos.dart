import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class SosBar extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const SosBar({super.key, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10.h, 5.v, 6.h, 14.v),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ScaleTransition(
              scale: pulseAnimation,
              child: GestureDetector(
                onTap: () => _showSosDialog(context),
                child: Container(
                  height: 56.v,
                  decoration: BoxDecoration(
                    color: AppColors.alert,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.alert.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: Colors.white,
                        size: 22.h,
                      ),
                      SizedBox(width: 8.h),
                      AppText(
                        'SOS ALERT',
                        size: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 56.v,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      color: AppColors.primary,
                      size: 18.h,
                    ),
                    SizedBox(width: 4.h),
                    AppText(
                      'Call',
                      size: 14,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSosDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.alert, size: 24.h),
            SizedBox(width: 8.h),
            AppText(
              'SOS Alert',
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        content: AppText(
          'Are you sure you want to send an SOS alert? Emergency contacts will be notified immediately.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              'Cancel',
              size: 13,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: AppText(
              'Send Alert',
              size: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}