import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:provider/provider.dart';

class EditPersonHeader extends StatelessWidget {
  final VoidCallback onBack;

  const EditPersonHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        final person = provider.person;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowStrong,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.h, 12.v, 20.h, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onBack,
                        child: Container(
                          width: 40.h,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundAlt,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18.h,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              person.name,
                              size: 17,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                            ),
                            AppText(
                              '${person.relationship.emoji}  ${person.relationship.label}',
                              size: 11,
                              color: AppColors.iconGrey,
                            ),
                          ],
                        ),
                      ),
                      _FaceStatusBadge(person: person),
                    ],
                  ),
                  SizedBox(height: 12.v),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FaceStatusBadge extends StatelessWidget {
  final dynamic person;

  const _FaceStatusBadge({required this.person});

  @override
  Widget build(BuildContext context) {
    final hasFace = person.hasFaceRegistered as bool;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
      decoration: BoxDecoration(
        color: hasFace ? AppColors.successLight : AppColors.amberLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasFace
                ? Icons.face_retouching_natural
                : Icons.face_retouching_off,
            size: 13.h,
            color: hasFace ? AppColors.successDark : AppColors.amber,
          ),
          SizedBox(width: 4.h),
          AppText(
            hasFace
                ? '${person.faceEmbeddingIds.length} face(s)'
                : 'No face',
            size: 11,
            color: hasFace ? AppColors.successDark : AppColors.amber,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}