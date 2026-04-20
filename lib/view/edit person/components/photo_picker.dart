import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/person_photo_sheet.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:provider/provider.dart';

class EditPersonPhotoPicker extends StatelessWidget {
  const EditPersonPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        final person = provider.person;

        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickPhoto(context, provider),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 90.h,
                      height: 90.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.08),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 2.5,
                        ),
                      ),
                      child: provider.newPhoto != null
                          ? ClipOval(
                              child: Image.file(
                                provider.newPhoto!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : person.photoUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    person.photoUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: AppText(
                                    person.name.isNotEmpty
                                        ? person.name[0].toUpperCase()
                                        : '?',
                                    size: 32,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                    ),
                    Container(
                      width: 30.h,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 14.h,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.v),
              AppText(
                'Tap photo to change',
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
    EditPersonProvider provider,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhotoSourceSheet(),
    );
    if (source == null || !context.mounted) return;
    await provider.pickPhoto(context, source);
  }
}