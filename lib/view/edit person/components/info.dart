import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/person_section.dart';
import 'package:lifelinker/core/widgets/pserson_relationship_chip.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/provider/edit_person.dart';
import 'package:lifelinker/view/edit%20person/components/edit_person_field.dart';
import 'package:lifelinker/view/edit%20person/components/photo_picker.dart';
import 'package:provider/provider.dart';

class EditPersonInfoTab extends StatelessWidget {
  final TabController tabController;

  const EditPersonInfoTab({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Consumer<EditPersonProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 32.v),
          child: Column(
            children: [
              const EditPersonPhotoPicker(),
              SizedBox(height: 20.v),
              _buildInfoCard(provider),
              SizedBox(height: 16.v),
              _buildRelationshipCard(context, provider),
              SizedBox(height: 28.v),
              _buildSaveButton(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(EditPersonProvider provider) {
    return PersonSectionCard(
      title: 'Personal Info',
      icon: Icons.person_outline_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primary.withOpacity(0.1),
      child: Column(
        children: [
          EditPersonTextField(
            controller: provider.nameController,
            hint: 'Full Name',
            icon: Icons.badge_outlined,
          ),
          SizedBox(height: 12.v),
          EditPersonTextField(
            controller: provider.phoneController,
            hint: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12.v),
          EditPersonTextField(
            controller: provider.notesController,
            hint: 'Notes',
            icon: Icons.notes_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipCard(
    BuildContext context,
    EditPersonProvider provider,
  ) {
    return PersonSectionCard(
      title: 'Relationship',
      icon: Icons.people_alt_rounded,
      iconColor: AppColors.amber,
      iconBg: AppColors.amberLight,
      child: Wrap(
        spacing: 8.h,
        runSpacing: 8.v,
        children: PersonRelationship.values
            .map(
              (r) => RelationshipChip(
                relationship: r,
                isSelected: provider.relationship == r,
                onTap: () => provider.setRelationship(r),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, EditPersonProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 54.v,
      child: ElevatedButton(
        onPressed: provider.isSaving
            ? null
            : () => provider.saveInfo(context, () {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: AppText(
                        'Changes saved successfully.',
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
              }),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: provider.isSaving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_rounded, color: Colors.white, size: 20.h),
                  SizedBox(width: 8.h),
                  AppText(
                    'Save Changes',
                    size: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
      ),
    );
  }
}
