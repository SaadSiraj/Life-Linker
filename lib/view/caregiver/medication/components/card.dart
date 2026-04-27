import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/medication.dart';
import 'package:lifelinker/view/caregiver/medication/components/status_badge.dart';

class MedCard extends StatelessWidget {
  final MedicationModel medication;

  const MedCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.v),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.h,
            height: 46.h,
            decoration: BoxDecoration(
              color: medication.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(medication.icon, color: Colors.white, size: 24.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  medication.name,
                  size: 15,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                Gap.v(4),
                AppText(medication.time, size: 13, color: AppColors.iconGrey),
              ],
            ),
          ),
          MedStatusBadge(status: medication.status),
        ],
      ),
    );
  }
}
