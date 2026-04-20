import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/view/edit%20person/components/face_processing_dialog.dart';
import 'package:lifelinker/view/edit%20person/components/face_recognition_result_dialog.dart';
import 'package:lifelinker/view/edit%20person/components/section_card.dart';
import 'package:provider/provider.dart';

class FaceRecognitionTestCard extends StatelessWidget {
  const FaceRecognitionTestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        final hasFace = provider.person.hasFaceRegistered;
        final firstName = provider.person.name.split(' ').first;

        return EditPersonSectionCard(
          title: 'Test Recognition',
          icon: Icons.search_rounded,
          iconColor: AppColors.amber,
          iconBg: AppColors.amberLight,
          child: Column(
            children: [
              AppText(
                'Capture a live photo to verify that the AI correctly identifies $firstName.',
                size: 12,
                color: AppColors.iconGrey,
              ),
              SizedBox(height: 14.v),
              SizedBox(
                width: double.infinity,
                height: 48.v,
                child: ElevatedButton(
                  onPressed: hasFace ? () => _runTest(context, provider) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    disabledBackgroundColor: AppColors.borderLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_enhance_rounded,
                        color: hasFace ? Colors.white : AppColors.iconGrey,
                        size: 20.h,
                      ),
                      SizedBox(width: 8.h),
                      AppText(
                        hasFace
                            ? 'Run Recognition Test'
                            : 'Register a face first',
                        size: 13,
                        color: hasFace ? Colors.white : AppColors.iconGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _runTest(
    BuildContext context,
    EditPersonProvider provider,
  ) async {
    await provider.testRecognition(
      context,
      onProcessingStart: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const FaceProcessingDialog(
            message: 'Running AI recognition…\nComparing face vectors.',
          ),
        );
      },
      onProcessingEnd: () {
        if (context.mounted) Navigator.pop(context);
      },
      onResult: (result) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (_) => FaceRecognitionResultDialog(
              result: result,
              person: provider.person,
            ),
          );
        }
      },
      onError: () {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppText(
                'Recognition failed. Try again.',
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