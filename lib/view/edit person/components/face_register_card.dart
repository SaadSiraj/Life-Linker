import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/view/edit%20person/components/face_processing_dialog.dart';
import 'package:lifelinker/view/edit%20person/components/section_card.dart';
import 'package:provider/provider.dart';

class FaceRegisterCard extends StatelessWidget {
  const FaceRegisterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditPersonSectionCard(
      title: 'Register Face Photos',
      icon: Icons.add_a_photo_rounded,
      iconColor: AppColors.blue,
      iconBg: AppColors.blueLight,
      child: Column(
        children: [
          AppText(
            'Add 3–5 clear photos for the best recognition results. Use different lighting and angles.',
            size: 12,
            color: AppColors.iconGrey,
          ),
          SizedBox(height: 16.v),
          Row(
            children: [
              Expanded(
                child: _SourceButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: AppColors.blue,
                  source: ImageSource.camera,
                ),
              ),
              SizedBox(width: 10.h),
              Expanded(
                child: _SourceButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: AppColors.purple,
                  source: ImageSource.gallery,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.v),
          const _FaceRegistrationTips(),
        ],
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final ImageSource source;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          onTap: () => _onTap(context, provider),
          child: Container(
            height: 54.v,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.25), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20.h),
                SizedBox(width: 8.h),
                AppText(label, size: 13, color: color, fontWeight: FontWeight.w600),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onTap(
    BuildContext context,
    EditPersonProvider provider,
  ) async {
    await provider.registerFaceFromSource(
      context,
      source,
      onProcessingStart: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const FaceProcessingDialog(
            message: 'Analysing face…\nThis may take a moment.',
          ),
        );
      },
      onProcessingEnd: () {
        if (context.mounted) Navigator.pop(context);
      },
      onSuccess: (embId) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                'Face registered successfully! (ID: ${embId.length > 8 ? '${embId.substring(0, 8)}…' : embId})',
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: AppColors.successDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
      onError: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                'Could not detect a face. Try again.',
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: AppColors.alert,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      },
    );
  }
}

class _FaceRegistrationTips extends StatelessWidget {
  const _FaceRegistrationTips();

  static const List<String> _tips = [
    '📸  Face must be clearly visible',
    '💡  Good, even lighting',
    '🔄  Try different angles',
    '🚫  Avoid sunglasses or hats',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _tips
            .map(
              (tip) => Padding(
                padding: EdgeInsets.symmetric(vertical: 3.v),
                child: Row(
                  children: [
                    AppText(tip, size: 11, color: AppColors.iconGrey),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}