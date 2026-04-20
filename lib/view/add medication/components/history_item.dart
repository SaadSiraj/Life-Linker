import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/med_history.dart';
import 'package:lifelinker/model/medication.dart';

class HistoryItem extends StatelessWidget {
  final MedHistoryItemModel item;

  const HistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool taken = item.status == MedStatus.taken;

    return Container(
      margin: EdgeInsets.only(bottom: 8.v),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 36.h,
            height: 36.h,
            decoration: BoxDecoration(
              color: taken
                  ? AppColors.success.withOpacity(0.12)
                  : AppColors.alert.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              taken ? Icons.check_rounded : Icons.close_rounded,
              color: taken ? AppColors.success : AppColors.alert,
              size: 18.h,
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name,
                  size: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
                AppText(item.time, size: 12, color: AppColors.iconGrey),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
            decoration: BoxDecoration(
              color: taken
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.alert.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText(
              taken ? 'Taken' : 'Missed',
              size: 11,
              color: taken ? AppColors.success : AppColors.alert,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
