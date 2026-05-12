import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PatientMedSummaryBar extends StatelessWidget {
  final double adherenceRate;
  final int totalMeds;

  const PatientMedSummaryBar({
    super.key,
    required this.adherenceRate,
    required this.totalMeds,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (adherenceRate * 100).toInt();
    Color color = AppColors.alert;
    if (percent >= 80)
      color = AppColors.successDark;
    else if (percent >= 50)
      color = AppColors.amber;

    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Today's Adherence",
                  size: 12,
                  color: AppColors.iconGrey,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                AppText(
                  '$percent%',
                  size: 26,
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: adherenceRate,
                    minHeight: SizeConfig.heightMultiplier * 0.8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 4),
          Column(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 14,
                height: SizeConfig.widthMultiplier * 14,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: AppColors.primary,
                  size: SizeConfig.widthMultiplier * 7,
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 0.5),
              AppText('$totalMeds meds', size: 11, color: AppColors.iconGrey),
            ],
          ),
        ],
      ),
    );
  }
}
