import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/model/medication.dart';

class MedStatusBadge extends StatelessWidget {
  final MedStatus status;

  const MedStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == MedStatus.none) {
      return Icon(
        Icons.chevron_right_rounded,
        color: AppColors.iconGrey,
        size: 22.h,
      );
    }

    final bool isTaken = status == MedStatus.taken;
    return Container(
      width: 34.h,
      height: 34.h,
      decoration: BoxDecoration(
        color: isTaken ? AppColors.success : AppColors.alert,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isTaken ? Icons.check_rounded : Icons.close_rounded,
        color: Colors.white,
        size: 18.h,
      ),
    );
  }
}
