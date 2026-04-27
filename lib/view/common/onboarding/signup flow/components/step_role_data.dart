import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:provider/provider.dart';

class StepRoleData extends StatelessWidget {
  const StepRoleData({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        final isPatient = provider.role == UserRole.patient;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIcon(isPatient),
            Gap.v(20),
            AppText(
              isPatient ? 'Patient Information' : 'Caregiver Details',
              size: 22,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
            Gap.v(6),
            AppText(
              isPatient
                  ? 'Medical details help caregivers provide better care.'
                  : 'Tell us about your caregiving role.',
              size: 13,
              color: AppColors.iconGrey,
            ),
            Gap.v(28),
            if (isPatient)
              _PatientFields(provider: provider)
            else
              _CaregiverFields(provider: provider),
          ],
        );
      },
    );
  }

  Widget _buildStepIcon(bool isPatient) {
    return Container(
      width: 56.h,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPatient
              ? [const Color(0xFF7B61FF), const Color(0xFF9B8BFF)]
              : [const Color(0xFF34C759), const Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                (isPatient ? const Color(0xFF7B61FF) : const Color(0xFF34C759))
                    .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        isPatient
            ? Icons.medical_information_outlined
            : Icons.volunteer_activism_rounded,
        color: Colors.white,
        size: 28.h,
      ),
    );
  }
}

// ─── Patient Fields ───────────────────────────────────────────────────────────

class _PatientFields extends StatelessWidget {
  final SignupProvider provider;
  const _PatientFields({required this.provider});

  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  static const List<String> _conditions = [
    "Alzheimer's Disease",
    'Dementia',
    'Parkinson\'s Disease',
    'Visual Impairment',
    'Hearing Impairment',
    'Mobility Disorder',
    'Autism Spectrum',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Medical Condition'),
        Gap.v(6),
        _DropdownField(
          controller: provider.conditionController,
          hint: 'Select condition',
          icon: Icons.medical_information_outlined,
          options: _conditions,
        ),
        Gap.v(16),
        _label('Blood Group'),
        Gap.v(6),
        _DropdownField(
          controller: provider.bloodGroupController,
          hint: 'Select blood group',
          icon: Icons.bloodtype_outlined,
          options: _bloodGroups,
        ),
        Gap.v(16),
        _label('Emergency Contact Number'),
        Gap.v(6),
        CustomTextField(
          controller: provider.emergencyContactController,
          hint: 'e.g. +92 300 1234567',
          prefixIcon: Icons.contact_phone_outlined,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _label(String text) => AppText(
    text,
    size: 13,
    color: AppColors.textMedium,
    fontWeight: FontWeight.w600,
  );
}

// ─── Caregiver Fields ─────────────────────────────────────────────────────────

class _CaregiverFields extends StatelessWidget {
  final SignupProvider provider;
  const _CaregiverFields({required this.provider});

  static const List<String> _relations = [
    'Son',
    'Daughter',
    'Spouse / Partner',
    'Parent',
    'Sibling',
    'Professional Caregiver',
    'Nurse',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('Relation to Patient'),
        Gap.v(6),
        _DropdownField(
          controller: provider.relationController,
          hint: 'Select your relation',
          icon: Icons.people_outline_rounded,
          options: _relations,
        ),
        Gap.v(16),
        _label('Organization / Hospital (Optional)'),
        Gap.v(6),
        CustomTextField(
          controller: provider.organizationController,
          hint: 'e.g. City Medical Center',
          prefixIcon: Icons.business_outlined,
        ),
        Gap.v(20),
        _InfoBanner(
          icon: Icons.info_outline_rounded,
          message:
              'As a caregiver, you\'ll be able to monitor your patient\'s location, medications, and health in real time.',
          color: AppColors.blueLight,
          iconColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _label(String text) => AppText(
    text,
    size: 13,
    color: AppColors.textMedium,
    fontWeight: FontWeight.w600,
  );
}

// ─── Reusable Dropdown Field ──────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final List<String> options;

  const _DropdownField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          hint: hint,
          prefixIcon: icon,
          readOnly: true,
          suffixWidget: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconGrey,
            size: 22.h,
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(
        options: options,
        selected: controller.text,
        onSelect: (val) {
          controller.text = val;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelect;

  const _PickerSheet({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap.v(8),
          Container(
            width: 36.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Gap.v(16),
          ...options.map((opt) {
            final isSelected = opt == selected;
            return GestureDetector(
              onTap: () => onSelect(opt),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.v),
                color: isSelected
                    ? AppColors.primary.withOpacity(0.06)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        opt,
                        size: 14,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textDark,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
                        size: 18.h,
                      ),
                  ],
                ),
              ),
            );
          }),
          Gap.v(16),
        ],
      ),
    );
  }
}

// ─── Info Banner ──────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  final Color iconColor;

  const _InfoBanner({
    required this.icon,
    required this.message,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20.h),
          Gap.h(10),
          Expanded(
            child: AppText(
              message,
              size: 12,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
