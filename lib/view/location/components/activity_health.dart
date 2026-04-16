import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/location.dart';

class LocationActivityHealth extends StatelessWidget {
  final LocationModel data;

  const LocationActivityHealth({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        SizeConfig.widthMultiplier * 4,
        SizeConfig.heightMultiplier * 1.8,
        SizeConfig.widthMultiplier * 4,
        0,
      ),
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Activity & Health',
            size: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.8),
          Row(
            children: [
              _ActivityStatCard(
                icon: Icons.directions_walk_rounded,
                iconColor: AppColors.primary,
                value: data.steps.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (m) => '${m[1]},',
                ),
                unit: 'Steps',
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2.5),
              _ActivityStatCard(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.alert,
                value: data.heartRate.toString(),
                unit: 'BPM',
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2.5),
              _ActivityStatCard(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.pending,
                value: data.calories.toString(),
                unit: 'Cal',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String unit;

  const _ActivityStatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 1.5,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: SizeConfig.widthMultiplier * 5.5),
            SizedBox(height: SizeConfig.heightMultiplier * 0.7),
            AppText(
              value,
              size: 15,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.2),
            AppText(
              unit,
              size: 11,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}