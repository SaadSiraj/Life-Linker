import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/profile/components/info_row.dart';
import 'package:lifelinker/view/profile/components/section_card.dart';

class CaregiverInfoCard extends StatelessWidget {
  final UserModel profile;

  const CaregiverInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Caregiver Information',
      icon: Icons.manage_accounts_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.blueLight,
      children: [
        InfoRow(
          label: 'Name',
          value: profile.caregiverName,
          icon: Icons.person_outline_rounded,
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
        InfoRow(
          label: 'Email',
          value: profile.caregiverEmail,
          icon: Icons.email_outlined,
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
        InfoRow(
          label: 'Phone',
          value: profile.caregiverPhone,
          icon: Icons.phone_outlined,
        ),
      ],
    );
  }
}