import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/profile/components/account_card.dart';
import 'package:lifelinker/view/profile/components/care_giver_info_card.dart';
import 'package:lifelinker/view/profile/components/edit_profile_sheet.dart';
import 'package:lifelinker/view/profile/components/header.dart';
import 'package:lifelinker/view/profile/components/notification_card.dart';
import 'package:lifelinker/view/profile/components/patient_info_card.dart';
import 'package:lifelinker/view/profile/components/safe_zone_card.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: AppColors.backgroundAlt,
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return _buildLoader();
          if (provider.hasError) return _buildError(provider);
          if (provider.profile == null) return const SizedBox.shrink();
          return _buildContent(context, provider);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: AppText(
        'Profile & Settings',
        size: 18,
        color: AppColors.textDark,
        fontWeight: FontWeight.w700,
      ),
      actions: [
        Consumer<ProfileProvider>(
          builder: (context, provider, _) => GestureDetector(
            onTap: () {
              if (provider.profile == null) return;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ChangeNotifierProvider.value(
                  value: provider,
                  child: const EditProfileSheet(),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 3.5,
                vertical: SizeConfig.heightMultiplier * 1,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppText(
                'Edit',
                size: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 4),
      ],
    );
  }

  Widget _buildContent(BuildContext context, ProfileProvider provider) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ProfileHeader(profile: provider.profile!)),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.widthMultiplier * 4,
            0,
            SizeConfig.widthMultiplier * 4,
            SizeConfig.heightMultiplier * 4,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: SizeConfig.heightMultiplier * 2.5),
              PatientInfoCard(profile: provider.profile!),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              CaregiverInfoCard(profile: provider.profile!),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              const SafeZoneCard(),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              const NotificationsCard(),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              const AccountCard(),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError(ProfileProvider provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: SizeConfig.widthMultiplier * 12,
            color: AppColors.iconGrey,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          AppText(
            'Failed to load profile',
            size: 14,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          TextButton(
            onPressed: provider.refresh,
            child: AppText(
              'Retry',
              size: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
