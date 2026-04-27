import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:provider/provider.dart';

class StepBasicInfo extends StatelessWidget {
  const StepBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SignupProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepIcon(),
        Gap.v(20),
        AppText(
          'Tell us about yourself',
          size: 22,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        Gap.v(6),
        AppText(
          'We need a few basic details to set up your profile.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        Gap.v(28),

        // Full Name
        _FieldLabel(label: 'Full Name'),
        Gap.v(6),
        CustomTextField(
          controller: provider.nameController,
          hint: 'e.g. John Doe',
          prefixIcon: Icons.person_outline_rounded,
          keyboardType: TextInputType.name,
        ),
        Gap.v(16),

        // Date of Birth
        _FieldLabel(label: 'Date of Birth'),
        Gap.v(6),
        Consumer<SignupProvider>(
          builder: (context, prov, _) => GestureDetector(
            onTap: () => prov.pickDateOfBirth(context),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: prov.dobController,
                hint: 'DD/MM/YYYY',
                prefixIcon: Icons.cake_outlined,
                readOnly: true,
              ),
            ),
          ),
        ),
        Gap.v(16),

        // Phone (optional)
        _FieldLabel(label: 'Phone Number (Optional)'),
        Gap.v(6),
        CustomTextField(
          controller: provider.phoneController,
          hint: 'e.g. +92 300 1234567',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildStepIcon() {
    return Container(
      width: 56.h,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4DA3FF), Color(0xFF2A7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.person_outline_rounded,
        color: Colors.white,
        size: 28.h,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return AppText(
      label,
      size: 13,
      color: AppColors.textMedium,
      fontWeight: FontWeight.w600,
    );
  }
}
