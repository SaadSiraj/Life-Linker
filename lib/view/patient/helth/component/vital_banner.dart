import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/health_record.dart';

class PatientVitalsBanner extends StatelessWidget {
  final HealthRecordModel record;
  const PatientVitalsBanner({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final allNormal =
        record.isHeartRateNormal &&
        record.isOxygenNormal &&
        record.isTempNormal &&
        record.isBpNormal;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: allNormal
              ? [AppColors.successDark, AppColors.success]
              : [AppColors.alert, const Color(0xFFFF6B6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                allNormal ? Icons.check_circle_rounded : Icons.warning_rounded,
                color: Colors.white,
                size: SizeConfig.widthMultiplier * 6,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              AppText(
                allNormal ? 'Vitals Normal' : 'Attention Needed',
                size: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BannerStat(
                'Heart',
                '${record.heartRate} bpm',
                record.isHeartRateNormal,
              ),
              _BannerStat('BP', record.bloodPressure, record.isBpNormal),
              _BannerStat(
                'SpO2',
                '${record.oxygenLevel}%',
                record.isOxygenNormal,
              ),
              _BannerStat(
                'Temp',
                '${record.temperature}°C',
                record.isTempNormal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String label;
  final String value;
  final bool isNormal;

  const _BannerStat(this.label, this.value, this.isNormal);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          value,
          size: 13,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.3),
        AppText(label, size: 10, color: Colors.white.withOpacity(0.8)),
        Icon(
          isNormal ? Icons.arrow_drop_up : Icons.arrow_drop_down,
          color: Colors.white,
          size: SizeConfig.widthMultiplier * 4,
        ),
      ],
    );
  }
}
