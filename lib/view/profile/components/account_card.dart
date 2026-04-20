import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/profile/components/action_row.dart';
import 'package:lifelinker/view/profile/components/section_card.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return SectionCard(
          title: 'Account',
          icon: Icons.settings_rounded,
          iconColor: AppColors.iconGrey,
          iconBg: AppColors.grey100,
          children: [
            ActionRow(
              label: 'Change Password',
              icon: Icons.lock_outline_rounded,
              color: AppColors.textDark,
              onTap: () {},
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.dividerLight,
            ),
            ActionRow(
              label: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              color: AppColors.textDark,
              onTap: () {},
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.dividerLight,
            ),
            ActionRow(
              label: 'Sign Out',
              icon: Icons.logout_rounded,
              color: AppColors.amber,
              onTap: () => _confirmSignOut(context, provider),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.dividerLight,
            ),
            ActionRow(
              label: 'Delete Account',
              icon: Icons.delete_forever_rounded,
              color: AppColors.alert,
              onTap: () => _confirmDeleteAccount(context),
            ),
          ],
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context, ProfileProvider provider) {
    _showConfirmDialog(
      context: context,
      title: 'Sign Out',
      message: 'You will need to sign in again to access LifeLinker.',
      confirmLabel: 'Sign Out',
      confirmColor: AppColors.amber,
      onConfirm: () => provider.signOut(context),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    _showConfirmDialog(
      context: context,
      title: 'Delete Account',
      message:
          'This will permanently delete all data. This action cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: AppColors.alert,
      onConfirm: () {},
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(
          title,
          size: 16,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        content: AppText(message, size: 13, color: AppColors.iconGrey),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              'Cancel',
              size: 13,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: AppText(
              confirmLabel,
              size: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
