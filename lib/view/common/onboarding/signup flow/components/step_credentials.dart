import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:provider/provider.dart';

class StepCredentials extends StatelessWidget {
  const StepCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepIcon(),
            Gap.v(20),
            AppText(
              'Secure Your Account',
              size: 22,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
            Gap.v(6),
            AppText(
              'Create a strong password to keep your account safe.',
              size: 13,
              color: AppColors.iconGrey,
            ),
            Gap.v(28),

            // Email
            _FieldLabel(label: 'Email Address'),
            Gap.v(6),
            CustomTextField(
              controller: provider.emailController,
              hint: 'you@example.com',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            Gap.v(16),

            // Password
            _FieldLabel(label: 'Password'),
            Gap.v(6),
            CustomTextField(
              controller: provider.passwordController,
              hint: 'Min. 6 characters',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: provider.obscurePassword,
              suffixWidget: IconButton(
                onPressed: provider.toggleObscurePassword,
                icon: Icon(
                  provider.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.iconGrey,
                  size: 20.h,
                ),
              ),
            ),
            Gap.v(16),

            // Confirm Password
            _FieldLabel(label: 'Confirm Password'),
            Gap.v(6),
            CustomTextField(
              controller: provider.confirmPasswordController,
              hint: 'Re-enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: provider.obscureConfirm,
              suffixWidget: IconButton(
                onPressed: provider.toggleObscureConfirm,
                icon: Icon(
                  provider.obscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.iconGrey,
                  size: 20.h,
                ),
              ),
            ),
            Gap.v(24),

            // Summary card
            _buildSummaryCard(provider),
          ],
        );
      },
    );
  }

  Widget _buildStepIcon() {
    return Container(
      width: 56.h,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF34C759), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF34C759).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.lock_outline_rounded,
        color: Colors.white,
        size: 28.h,
      ),
    );
  }

  Widget _buildSummaryCard(SignupProvider provider) {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_pin_rounded,
                  color: AppColors.primary, size: 18.h),
              Gap.h(8),
              AppText(
                'Account Summary',
                size: 13,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          Gap.v(12),
          _SummaryRow(
            icon: Icons.badge_outlined,
            label: 'Name',
            value: provider.nameController.text.isEmpty
                ? '—'
                : provider.nameController.text,
          ),
          Gap.v(6),
          _SummaryRow(
            icon: Icons.verified_user_outlined,
            label: 'Role',
            value:
                provider.role == UserRole.patient ? 'Patient 🧓' : 'Caregiver 🩺',
          ),
          if (provider.dob.isNotEmpty) ...[
            Gap.v(6),
            _SummaryRow(
              icon: Icons.cake_outlined,
              label: 'DOB',
              value: provider.dobController.text,
            ),
          ],
        ],
      ),
    );
  }
}

extension on SignupProvider {
  String get dob => dobController.text;
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

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15.h, color: AppColors.iconGrey),
        Gap.h(8),
        AppText(
          '$label:  ',
          size: 12,
          color: AppColors.iconGrey,
          fontWeight: FontWeight.w500,
        ),
        AppText(
          value,
          size: 12,
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}