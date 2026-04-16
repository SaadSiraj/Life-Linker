import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/location.dart';

class LocationPatientCard extends StatelessWidget {
  final LocationModel data;

  const LocationPatientCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 4,
        vertical: SizeConfig.heightMultiplier * 1.8,
      ),
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
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: SizeConfig.widthMultiplier * 7,
                backgroundColor: AppColors.border,
                child: Icon(
                  Icons.person_rounded,
                  size: SizeConfig.widthMultiplier * 8,
                  color: AppColors.iconGrey,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: SizeConfig.widthMultiplier * 3.5,
                  height: SizeConfig.widthMultiplier * 3.5,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data.patientName,
                  size: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 2,
                        vertical: SizeConfig.heightMultiplier * 0.3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AppText(
                        data.patientStatus,
                        size: 11,
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                    AppText(
                      data.lastSeen,
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 5.5,
          ),
        ],
      ),
    );
  }
}