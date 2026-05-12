import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/health_record.dart';

class HealthRecordCard extends StatelessWidget {
  final HealthRecordModel record;
  final VoidCallback onDelete;

  const HealthRecordCard({super.key, required this.record, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadowStrong, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                DateFormat('dd MMM yyyy  hh:mm a').format(record.recordedAt),
                size: 11, color: AppColors.iconGrey,
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete_outline_rounded,
                    size: SizeConfig.widthMultiplier * 4.5,
                    color: AppColors.alert),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.2),
          Row(
            children: [
              _Item(icon: Icons.favorite_rounded,
                  color: record.isHeartRateNormal ? AppColors.successDark : AppColors.alert,
                  label: '${record.heartRate} bpm'),
              _Item(icon: Icons.monitor_heart_outlined,
                  color: record.isBpNormal ? AppColors.successDark : AppColors.alert,
                  label: record.bloodPressure),
              _Item(icon: Icons.air_rounded,
                  color: record.isOxygenNormal ? AppColors.successDark : AppColors.alert,
                  label: '${record.oxygenLevel}%'),
              _Item(icon: Icons.thermostat_rounded,
                  color: record.isTempNormal ? AppColors.successDark : AppColors.alert,
                  label: '${record.temperature}°C'),
            ],
          ),
          if (record.weight > 0) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 0.8),
            Row(
              children: [
                Icon(Icons.monitor_weight_outlined,
                    size: SizeConfig.widthMultiplier * 4,
                    color: AppColors.iconGrey),
                SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                AppText('${record.weight} kg', size: 12, color: AppColors.iconGrey),
              ],
            ),
          ],
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 0.8),
            AppText(record.notes!, size: 11, color: AppColors.iconGrey,
                maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _Item({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: SizeConfig.widthMultiplier * 4),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          Flexible(child: AppText(label, size: 11, color: AppColors.textDark,
              fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}