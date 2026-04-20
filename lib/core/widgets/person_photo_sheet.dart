import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class PhotoSourceSheet extends StatelessWidget {
  const PhotoSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.v),
          Container(
            width: 36.h,
            height: 4.v,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16.v),
          AppText(
            'Choose Photo Source',
            size: 14,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 16.v),
          _SourceRow(
            icon: Icons.camera_alt_rounded,
            label: 'Take a Photo',
            subtitle: 'Best for face recognition',
            source: ImageSource.camera,
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _SourceRow(
            icon: Icons.photo_library_rounded,
            label: 'Choose from Gallery',
            subtitle: 'Select an existing photo',
            source: ImageSource.gallery,
          ),
          SizedBox(height: 16.v),
        ],
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final ImageSource source;

  const _SourceRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.v),
        child: Row(
          children: [
            Container(
              width: 42.h,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.h),
            ),
            SizedBox(width: 14.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  label,
                  size: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w600,
                ),
                AppText(subtitle, size: 11, color: AppColors.iconGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
