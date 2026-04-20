import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/face_recongnition.dart';
import 'package:lifelinker/model/known_person.dart';

class FaceRecognitionResultDialog extends StatelessWidget {
  final FaceRecognitionResult result;
  final KnownPerson person;

  const FaceRecognitionResultDialog({
    super.key,
    required this.result,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = result.matched && result.matchedPersonId == person.id;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.all(24.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ResultIcon(isSuccess: isSuccess),
          SizedBox(height: 16.v),
          _ResultTitle(isSuccess: isSuccess),
          SizedBox(height: 8.v),
          _ResultBody(result: result, person: person, isSuccess: isSuccess),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSuccess
                  ? AppColors.successDark
                  : AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              minimumSize: Size(140.h, 44.v),
            ),
            child: AppText(
              'Done',
              size: 14,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 4.v),
      ],
    );
  }
}

class _ResultIcon extends StatelessWidget {
  final bool isSuccess;

  const _ResultIcon({required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.h,
      height: 64.h,
      decoration: BoxDecoration(
        color: isSuccess ? AppColors.successLight : AppColors.alertLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
        size: 36.h,
        color: isSuccess ? AppColors.successDark : AppColors.alert,
      ),
    );
  }
}

class _ResultTitle extends StatelessWidget {
  final bool isSuccess;

  const _ResultTitle({required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return AppText(
      isSuccess ? 'Match Found! ✓' : 'No Match',
      size: 18,
      color: isSuccess ? AppColors.successDark : AppColors.alert,
      fontWeight: FontWeight.w700,
    );
  }
}

class _ResultBody extends StatelessWidget {
  final FaceRecognitionResult result;
  final KnownPerson person;
  final bool isSuccess;

  const _ResultBody({
    required this.result,
    required this.person,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    if (!result.faceDetected) {
      return AppText(
        'No face detected in image.',
        size: 13,
        color: AppColors.iconGrey,
        align: TextAlign.center,
      );
    }

    if (isSuccess) {
      return Column(
        children: [
          AppText(
            'Identified as ${person.name}',
            size: 14,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            align: TextAlign.center,
          ),
          SizedBox(height: 6.v),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppText(
              'Confidence: ${((result.confidence ?? 0) * 100).toStringAsFixed(1)}%',
              size: 13,
              color: AppColors.successText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return AppText(
      'The face did not match ${person.name}. Try adding more photos.',
      size: 13,
      color: AppColors.iconGrey,
      align: TextAlign.center,
    );
  }
}
