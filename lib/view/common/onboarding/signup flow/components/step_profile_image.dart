import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/signup.dart';
import 'package:provider/provider.dart';

class StepProfileImage extends StatelessWidget {
  const StepProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildStepIcon(),
            Gap.v(20),
            AppText(
              'Add a Profile Photo',
              size: 22,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
              align: TextAlign.center,
            ),
            Gap.v(6),
            AppText(
              'A photo helps others recognise you. You can skip this step.',
              size: 13,
              color: AppColors.iconGrey,
              align: TextAlign.center,
            ),
            Gap.v(36),

            // ── Avatar ───────────────────────────────────────────────────────
            _buildAvatar(context, provider),

            Gap.v(24),

            // ── Action Buttons ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  onTap: () async {
                    await provider.pickPhoto(context, ImageSource.camera);
                  },
                ),
                Gap.h(16),
                _ActionButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  onTap: () async {
                    await provider.pickPhoto(context, ImageSource.gallery);
                  },
                ),
                if (provider.profileImage != null) ...[
                  Gap.h(16),
                  _ActionButton(
                    icon: Icons.delete_outline_rounded,
                    label: 'Remove',
                    color: AppColors.alert,
                    bgColor: AppColors.alertLight,
                    onTap: () => provider.clearProfileImage(),
                  ),
                ],
              ],
            ),

            Gap.v(32),
            _buildTip(),
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
          colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.face_retouching_natural_rounded,
        color: Colors.white,
        size: 28.h,
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, SignupProvider provider) {
    return GestureDetector(
      onTap: () => _showImagePickerSheet(context, provider),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 130.h,
            height: 130.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(
                color: provider.profileImage != null
                    ? AppColors.primary
                    : AppColors.border,
                width: provider.profileImage != null ? 3 : 1.5,
              ),
              boxShadow: provider.profileImage != null
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
              image: provider.profileImage != null
                  ? DecorationImage(
                      image: FileImage(provider.profileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: provider.profileImage == null
                ? Icon(
                    Icons.person_rounded,
                    size: 64.h,
                    color: AppColors.primary.withOpacity(0.5),
                  )
                : null,
          ),
          Container(
            width: 36.h,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 18.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip() {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: AppColors.amberLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.amber,
            size: 20.h,
          ),
          Gap.h(10),
          Expanded(
            child: AppText(
              'A clear, front-facing photo helps your caregiver and the app identify you accurately.',
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

  void _showImagePickerSheet(BuildContext context, SignupProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ImagePickerBottomSheet(
        onPickImage: (source) async {
          await provider.pickPhoto(context, source);
        },
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? bgColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.h,
            height: 56.h,
            decoration: BoxDecoration(
              color: bgColor ?? AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color ?? AppColors.primary, size: 26.h),
          ),
          Gap.v(6),
          AppText(
            label,
            size: 11,
            color: color ?? AppColors.textMedium,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

// ─── Custom Image Picker Bottom Sheet ─────────────────────────────────────────
// Reusable - can be called from anywhere in the app

class ImagePickerBottomSheet extends StatelessWidget {
  final Future<void> Function(ImageSource source) onPickImage;
  final String? title;

  const ImagePickerBottomSheet({
    super.key,
    required this.onPickImage,
    this.title,
  });

  /// Static show method — use this to open from anywhere
  static Future<void> show(
    BuildContext context, {
    required Future<void> Function(ImageSource source) onPickImage,
    String? title,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) =>
          ImagePickerBottomSheet(onPickImage: onPickImage, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12.h, 0, 12.h, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap.v(10),
          // Drag handle
          Container(
            width: 40.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Gap.v(16),
          AppText(
            title ?? 'Choose Photo Source',
            size: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          Gap.v(20),

          // Camera option
          _OptionTile(
            icon: Icons.camera_alt_rounded,
            iconColor: const Color(0xFF3B82F6),
            iconBg: const Color(0xFFEFF6FF),
            label: 'Take a Photo',
            subtitle: 'Use your camera right now',
            onTap: () async {
              Navigator.pop(context);
              await onPickImage(ImageSource.camera);
            },
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: const Divider(height: 1, color: AppColors.dividerLight),
          ),

          // Gallery option
          _OptionTile(
            icon: Icons.photo_library_rounded,
            iconColor: const Color(0xFF8B5CF6),
            iconBg: const Color(0xFFF5F3FF),
            label: 'Choose from Gallery',
            subtitle: 'Pick an existing photo',
            onTap: () async {
              Navigator.pop(context);
              await onPickImage(ImageSource.gallery);
            },
          ),
          Gap.v(12),

          // Cancel button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.fromLTRB(16.h, 0, 16.h, 0),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.v),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AppText(
                'Cancel',
                size: 14,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w600,
                align: TextAlign.center,
              ),
            ),
          ),
          Gap.v(16),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.v),
        child: Row(
          children: [
            Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24.h),
            ),
            Gap.h(14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  size: 14,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                Gap.v(2),
                AppText(subtitle, size: 12, color: AppColors.iconGrey),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.h,
              color: AppColors.iconGrey,
            ),
          ],
        ),
      ),
    );
  }
}
