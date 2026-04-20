import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/medication.dart';
import 'package:lifelinker/model/scheduled_medication.dart';

class ScheduleCard extends StatelessWidget {
  final ScheduledMedicationModel item;

  const ScheduleCard({super.key, required this.item});

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
              color: item.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: Colors.white, size: 24.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name,
                  size: 15,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                Gap.v(4),
                AppText(item.time, size: 13, color: AppColors.iconGrey),
              ],
            ),
          ),
          _StatusChip(status: item.status),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final MedStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;
    String label;
    IconData? icon;

    switch (status) {
      case MedStatus.pending:
        bg = AppColors.pending.withOpacity(0.12);
        textColor = AppColors.pending;
        label = 'Pending';
        break;
      case MedStatus.taken:
        bg = AppColors.success.withOpacity(0.12);
        textColor = AppColors.success;
        label = 'Taken';
        break;
      case MedStatus.missed:
        bg = AppColors.alert.withOpacity(0.12);
        textColor = AppColors.alert;
        label = '';
        icon = Icons.info_rounded;
        break;
      default:
        bg = AppColors.border;
        textColor = AppColors.iconGrey;
        label = '';
    }

    if (icon != null) {
      return Icon(icon, color: textColor, size: 24.h);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 5.v),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(label, size: 12, color: textColor, fontWeight: FontWeight.w600),
    );
  }
}