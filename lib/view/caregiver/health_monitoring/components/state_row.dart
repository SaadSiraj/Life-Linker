import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/health_record.dart';

class HealthStatsRow extends StatelessWidget {
  final HealthRecordModel record;
  const HealthStatsRow({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadowStrong, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Latest Vitals', size: 13,
              color: AppColors.iconGrey, fontWeight: FontWeight.w600),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            children: [
              _VitalTile(label: 'Heart Rate',
                  value: '${record.heartRate}', unit: 'bpm',
                  icon: Icons.favorite_rounded,
                  color: record.isHeartRateNormal ? AppColors.successDark : AppColors.alert),
              _VitalTile(label: 'BP',
                  value: record.bloodPressure, unit: 'mmHg',
                  icon: Icons.monitor_heart_outlined,
                  color: record.isBpNormal ? AppColors.successDark : AppColors.alert),
              _VitalTile(label: 'SpO2',
                  value: '${record.oxygenLevel}', unit: '%',
                  icon: Icons.air_rounded,
                  color: record.isOxygenNormal ? AppColors.successDark : AppColors.alert),
              _VitalTile(label: 'Temp',
                  value: '${record.temperature}', unit: '°C',
                  icon: Icons.thermostat_rounded,
                  color: record.isTempNormal ? AppColors.successDark : AppColors.alert),
            ],
          ),
        ],
      ),
    );
  }
}

class _VitalTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _VitalTile({
    required this.label, required this.value, required this.unit,
    required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 10,
            height: SizeConfig.widthMultiplier * 10,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: SizeConfig.widthMultiplier * 5),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 0.6),
          AppText(value, size: 13, color: AppColors.textDark,
              fontWeight: FontWeight.w700),
          AppText(unit, size: 9, color: AppColors.iconGrey),
          SizedBox(height: SizeConfig.heightMultiplier * 0.3),
          AppText(label, size: 9, color: AppColors.iconGrey,
              align: TextAlign.center),
        ],
      ),
    );
  }
}