import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16.v),
          AppText(
            'Loading patient data…',
            size: 13,
            color: AppColors.iconGrey,
          ),
        ],
      ),
    );
  }
}

class DashboardErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const DashboardErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 52.h, color: AppColors.iconGrey),
            SizedBox(height: 16.v),
            AppText(
              'Could not load dashboard',
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 8.v),
            AppText(
              'Check your connection and try again.',
              size: 13,
              color: AppColors.iconGrey,
              align: TextAlign.center,
            ),
            SizedBox(height: 24.v),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(
                  horizontal: 32.h,
                  vertical: 12.v,
                ),
              ),
              child: AppText(
                'Retry',
                size: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}