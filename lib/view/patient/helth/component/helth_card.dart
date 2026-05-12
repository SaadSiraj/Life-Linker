import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/health_record.dart';

class PatientHealthCard extends StatelessWidget {
  final HealthRecordModel record;
  const PatientHealthCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.shadowStrong, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            DateFormat('dd MMM yyyy  hh:mm a').format(record.recordedAt),
            size: 11,
            color: AppColors.iconGrey,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.2),
          Wrap(
            spacing: SizeConfig.widthMultiplier * 2,
            runSpacing: SizeConfig.heightMultiplier * 0.8,
            children: [
              _Chip(
                Icons.favorite_rounded,
                '${record.heartRate} bpm',
                record.isHeartRateNormal,
              ),
              _Chip(
                Icons.monitor_heart_outlined,
                record.bloodPressure,
                record.isBpNormal,
              ),
              _Chip(
                Icons.air_rounded,
                '${record.oxygenLevel}%',
                record.isOxygenNormal,
              ),
              _Chip(
                Icons.thermostat_rounded,
                '${record.temperature}°C',
                record.isTempNormal,
              ),
            ],
          ),
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            AppText(record.notes!, size: 11, color: AppColors.iconGrey),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isNormal;

  const _Chip(this.icon, this.label, this.isNormal);

  @override
  Widget build(BuildContext context) {
    final color = isNormal ? AppColors.successDark : AppColors.alert;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2.5,
        vertical: SizeConfig.heightMultiplier * 0.5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: SizeConfig.widthMultiplier * 3.5),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          AppText(label, size: 11, color: color, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
