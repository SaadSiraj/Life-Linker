import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/profile/components/section_card.dart';
import 'package:lifelinker/view/profile/components/toggle_row.dart';
import 'package:provider/provider.dart';

class SafeZoneCard extends StatelessWidget {
  const SafeZoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        final safeZone = provider.safeZone;
        return SectionCard(
          title: 'Safe Zone (Geofencing)',
          icon: Icons.location_on_rounded,
          iconColor: AppColors.blue,
          iconBg: AppColors.blueLight,
          children: [
            ToggleRow(
              label: 'Enable Safe Zone',
              subtitle: 'Alert when patient leaves zone',
              value: safeZone.enabled,
              onChanged: provider.setSafeZoneEnabled,
              activeColor: AppColors.blue,
            ),
            if (safeZone.enabled) ...[
              const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
              _buildZoneCenterRow(context, safeZone.centerLabel),
              const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
              _buildRadiusSlider(context, provider),
              const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
              _buildMapPreview(context),
            ],
          ],
        );
      },
    );
  }

  Widget _buildZoneCenterRow(BuildContext context, String centerLabel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.5,
      ),
      child: Row(
        children: [
          Icon(
            Icons.home_rounded,
            size: SizeConfig.widthMultiplier * 4.5,
            color: AppColors.blue,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Zone Center',
                  size: 11,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                AppText(
                  centerLabel,
                  size: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showSetZoneCenterSnackbar(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 2.5,
                vertical: SizeConfig.heightMultiplier * 0.6,
              ),
              decoration: BoxDecoration(
                color: AppColors.blueLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                'Change',
                size: 11,
                color: AppColors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiusSlider(BuildContext context, ProfileProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 1.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                'Safe Radius',
                size: 13,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 2.5,
                  vertical: SizeConfig.heightMultiplier * 0.5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText(
                  '${provider.safeZone.radiusMeters.toInt()} m',
                  size: 12,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.blue,
              inactiveTrackColor: AppColors.grey200,
              thumbColor: AppColors.blue,
              overlayColor: AppColors.blue.withOpacity(0.12),
              trackHeight: 4,
            ),
            child: Slider(
              min: 50,
              max: 1000,
              divisions: 19,
              value: provider.safeZone.radiusMeters,
              onChanged: provider.setSafeZoneRadius,
              onChangeEnd: (_) => provider.commitSafeZoneRadius(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText('50 m', size: 10, color: AppColors.iconGrey),
              AppText('1000 m', size: 10, color: AppColors.iconGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 14,
      margin: EdgeInsets.only(
        top: SizeConfig.heightMultiplier * 1.5,
        bottom: SizeConfig.heightMultiplier * 0.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blueLighter, width: 1.5),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_rounded,
                  size: SizeConfig.widthMultiplier * 9,
                  color: AppColors.blueLighter,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.8),
                AppText(
                  'Tap to open map & set zone',
                  size: 12,
                  color: AppColors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          Positioned(
            top: SizeConfig.heightMultiplier * 1,
            right: SizeConfig.widthMultiplier * 2,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 2,
                vertical: SizeConfig.heightMultiplier * 0.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: AppText(
                'Open Map',
                size: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSetZoneCenterSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(
          'Open map to set zone center',
          size: 13,
          color: Colors.white,
        ),
        backgroundColor: AppColors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}