import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/time_slot.dart';

class TimeSlotRow extends StatelessWidget {
  final TimeSlotModel slot;

  const TimeSlotRow({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 66.h,
          child: Padding(
            padding: EdgeInsets.only(top: 12.v),
            child: AppText(
              slot.time,
              size: 12,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              width: 12.h,
              height: 12.h,
              margin: EdgeInsets.only(top: 14.v),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: ((slot.medications.length * 56) + 10).v,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ],
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: Column(
            children: slot.medications
                .map((med) => _MedSlotCard(name: med))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _MedSlotCard extends StatelessWidget {
  final String name;

  const _MedSlotCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.v),
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(Icons.medication_rounded, color: AppColors.primary, size: 18.h),
          SizedBox(width: 8.h),
          Expanded(
            child: AppText(
              name,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            Icons.notifications_outlined,
            color: AppColors.iconGrey,
            size: 18.h,
          ),
        ],
      ),
    );
  }
}
