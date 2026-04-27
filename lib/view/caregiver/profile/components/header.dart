import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEditTap;

  const ProfileHeader({super.key, required this.user, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.appBarGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.widthMultiplier * 5,
            SizeConfig.heightMultiplier * 2,
            SizeConfig.widthMultiplier * 5,
            SizeConfig.heightMultiplier * 4,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    'Profile',
                    size: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  if (onEditTap != null)
                    GestureDetector(
                      onTap: onEditTap,
                      child: Container(
                        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: SizeConfig.widthMultiplier * 5,
                        ),
                      ),
                    ),
                ],
              ),
              Spacing.y(3),
              _buildAvatar(),
              Spacing.y(1.5),
              AppText(
                user.name,
                size: 20,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              Spacing.y(0.5),
              AppText(
                user.email,
                size: 12,
                color: Colors.white.withOpacity(0.8),
              ),
              Spacing.y(1),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 4,
                  vertical: SizeConfig.heightMultiplier * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AppText(
                  user.roleLabel,
                  size: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: SizeConfig.widthMultiplier * 24,
      height: SizeConfig.widthMultiplier * 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.3),
        border: Border.all(color: Colors.white, width: 3),
        image: user.profileImageUrl != null
            ? DecorationImage(
                image: NetworkImage(user.profileImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: user.profileImageUrl == null
          ? Icon(
              Icons.person_rounded,
              size: SizeConfig.widthMultiplier * 12,
              color: Colors.white,
            )
          : null,
    );
  }
}
