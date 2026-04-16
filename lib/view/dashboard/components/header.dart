import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/dashboard.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardModel data;

  const DashboardHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
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
          padding: EdgeInsets.fromLTRB(20.h, 16.v, 20.h, 24.v),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28.h,
                backgroundColor: AppColors.cardWhite.withOpacity(0.12),
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.cardWhite,
                  size: 30.h,
                ),
              ),
              SizedBox(width: 14.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      data.patientName,
                      size: 20,
                      color: AppColors.cardWhite,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 4.v),
                    _buildSafeStatusBadge(),
                  ],
                ),
              ),
              _buildMonitoredBadge(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafeStatusBadge() {
    return Container(
      width: 80.h,
      height: 20.h,
      decoration: BoxDecoration(
        color: data.isSafe ? AppColors.successLight : AppColors.alertLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8.h,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    data.isSafe ? AppColors.successDark : AppColors.alert,
              ),
            ),
            SizedBox(width: 4.h),
            AppText(
              data.isSafe ? 'Safe' : 'Danger',
              size: 13,
              color: data.isSafe ? AppColors.successDark : AppColors.alert,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoredBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
      decoration: BoxDecoration(
        color: data.isSafe ? AppColors.successLight : AppColors.alertLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        data.isSafe ? '✓ Monitored' : '⚠ Alert',
        size: 12,
        color: data.isSafe ? AppColors.successText : AppColors.alert,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}