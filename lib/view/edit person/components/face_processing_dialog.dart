import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class FaceProcessingDialog extends StatelessWidget {
  final String message;

  const FaceProcessingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48.h,
              height: 48.h,
              child: const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 20.v),
            AppText(
              message,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}