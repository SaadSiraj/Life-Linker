import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_confirm_dialog.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/caregiver/profile/components/header.dart';
import 'package:lifelinker/view/caregiver/profile/components/info_card.dart';
import 'package:lifelinker/view/common/edit_profile/edit_profile.dart';
import 'package:provider/provider.dart';

class CaregiverProfileView extends StatefulWidget {
  const CaregiverProfileView({super.key});

  @override
  State<CaregiverProfileView> createState() => _CaregiverProfileViewState();
}

class _CaregiverProfileViewState extends State<CaregiverProfileView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.hasError || provider.user == null) {
            return _buildError(provider);
          }

          final user = provider.user!;

          return RefreshIndicator(
            onRefresh: provider.loadProfile,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ProfileHeader(
                    user: user,
                    onEditTap: () => _openEditProfile(context, provider),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                    child: Column(
                      children: [
                        Spacing.y(1),
                        ProfileInfoCard(
                          title: 'Personal Information',
                          icon: Icons.person_outline_rounded,
                          iconColor: AppColors.blue,
                          iconBg: AppColors.blueLight,
                          rows: [
                            ProfileInfoRow(
                              icon: Icons.cake_outlined,
                              label: 'Date of Birth',
                              value: user.dob ?? '',
                            ),
                            ProfileInfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: user.phone ?? '',
                            ),
                            ProfileInfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: user.email,
                            ),
                          ],
                        ),
                        Spacing.y(2),
                        ProfileInfoCard(
                          title: 'Caregiver Details',
                          icon: Icons.volunteer_activism_rounded,
                          iconColor: AppColors.successDark,
                          iconBg: AppColors.successLight,
                          rows: [
                            ProfileInfoRow(
                              icon: Icons.people_outline_rounded,
                              label: 'Relation',
                              value: user.relation ?? '',
                            ),
                          ],
                        ),
                        Spacing.y(3),

                        // ── Logout Button ─────────────────────────────────
                        _buildLogoutButton(context, provider),
                        Spacing.y(3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ProfileProvider provider) {
    return GestureDetector(
      onTap: () => _confirmLogout(context, provider),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier * 1.8,
        ),
        decoration: BoxDecoration(
          color: AppColors.alertLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.alert.withOpacity(0.3)),
        ),
        child: provider.isLoggingOut
            ? Center(
                child: SizedBox(
                  width: SizeConfig.heightMultiplier * 2.5,
                  height: SizeConfig.heightMultiplier * 2.5,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.alert,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: AppColors.alert,
                    size: SizeConfig.widthMultiplier * 5.5,
                  ),
                  SizedBox(width: SizeConfig.widthMultiplier * 2.5),
                  AppText(
                    'Logout',
                    size: 15,
                    color: AppColors.alert,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, ProfileProvider provider) {
    AppConfirmDialog.show(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout from LifeLinker?',
      confirmLabel: 'Logout',
      isDestructive: true,
      onConfirm: () async {
        await provider.logout();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.login,
            (_) => false,
          );
        }
      },
    );
  }

  void _openEditProfile(
    BuildContext context,
    ProfileProvider profileProvider,
  ) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileView()),
    );
    if (updated != null && context.mounted) {
      profileProvider.updateLocally(updated);
    }
  }

  Widget _buildError(ProfileProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 15,
          ),
          Spacing.y(2),
          AppText(
            'Failed to load profile',
            size: 14,
            color: AppColors.iconGrey,
          ),
          Spacing.y(1.5),
          GestureDetector(
            onTap: provider.loadProfile,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 5,
                vertical: SizeConfig.heightMultiplier * 1.2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: AppText(
                'Retry',
                size: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
