import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/profile/components/info_row.dart';
import 'package:lifelinker/view/profile/components/section_card.dart';

class PatientInfoCard extends StatelessWidget {
  final UserModel profile;

  const PatientInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Patient Information',
      icon: Icons.elderly_rounded,
      iconColor: AppColors.purple,
      iconBg: AppColors.purpleLight,
      children: [
        InfoRow(
          label: 'Full Name',
          value: profile.patientName,
          icon: Icons.person_outline_rounded,
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
        InfoRow(
          label: 'Age',
          value: '${profile.patientAge} years',
          icon: Icons.cake_outlined,
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
        InfoRow(
          label: 'Condition',
          value: profile.patientCondition,
          icon: Icons.medical_information_outlined,
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
        InfoRow(
          label: 'Blood Group',
          value: profile.patientBloodGroup,
          icon: Icons.bloodtype_outlined,
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.dividerLight),
        InfoRow(
          label: 'Emergency Contact',
          value: profile.patientEmergencyContact,
          icon: Icons.contact_phone_outlined,
        ),
      ],
    );
  }
}
