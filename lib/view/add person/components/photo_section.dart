import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/person_photo_sheet.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPersonPhotoSection extends StatelessWidget {
  const AddPersonPhotoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, _) {
        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickPhoto(context, provider),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100.h,
                      height: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.08),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2.5,
                        ),
                      ),
                      child: provider.pickedPhoto != null
                          ? ClipOval(
                              child: Image.file(
                                provider.pickedPhoto!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.person_rounded,
                              size: 48.h,
                              color: AppColors.primary.withOpacity(0.4),
                            ),
                    ),
                    Container(
                      width: 32.h,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 15.h,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.v),
              AppText(
                'Tap to add a photo',
                size: 12,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 4.v),
              AppText(
                'Used for face recognition training',
                size: 11,
                color: AppColors.iconGrey,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickPhoto(
    BuildContext context,
    AddPersonProvider provider,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhotoSourceSheet(),
    );
    if (source == null) return;
    if (context.mounted) {
      await provider.pickPhoto(context, source);
    }
  }
}