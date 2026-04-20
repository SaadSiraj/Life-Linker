import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:provider/provider.dart';

class FaceInfoBanner extends StatelessWidget {
  const FaceInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        final firstName = provider.person.name.split(' ').first;

        return Container(
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.08),
                AppColors.primary.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.15),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 18.h,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'AI Face Recognition',
                      size: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 4.v),
                    AppText(
                      'Register multiple photos for better accuracy. The AI will identify $firstName and announce who they are to the patient.',
                      size: 11,
                      color: AppColors.textDark.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}