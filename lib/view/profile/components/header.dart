import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/profile/components/stat_pill.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.widthMultiplier * 5,
            SizeConfig.heightMultiplier * 1.5,
            SizeConfig.widthMultiplier * 5,
            SizeConfig.heightMultiplier * 3,
          ),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.heightMultiplier * 3),
              _buildAvatar(),
              SizedBox(height: SizeConfig.heightMultiplier * 1.5),
              AppText(
                profile.caregiverName,
                size: 20,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 0.5),
              AppText(
                profile.caregiverEmail,
                size: 13,
                color: AppColors.iconGrey,
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              _buildStatPills(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: SizeConfig.widthMultiplier * 20,
          height: SizeConfig.widthMultiplier * 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: SizeConfig.widthMultiplier * 9.5,
          ),
        ),
        Container(
          width: SizeConfig.widthMultiplier * 6.5,
          height: SizeConfig.widthMultiplier * 6.5,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.backgroundAlt, width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4),
            ],
          ),
          child: Icon(
            Icons.camera_alt_rounded,
            size: SizeConfig.widthMultiplier * 3.5,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatPills() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ProfileStatPill(
          icon: Icons.shield_rounded,
          label: 'Caregiver',
          color: AppColors.primary,
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2.5),
        ProfileStatPill(
          icon: Icons.verified_rounded,
          label: 'Verified',
          color: AppColors.successDark,
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2.5),
        ProfileStatPill(
          icon: Icons.notifications_active_rounded,
          label: 'Alerts On',
          color: AppColors.amber,
        ),
      ],
    );
  }
}
