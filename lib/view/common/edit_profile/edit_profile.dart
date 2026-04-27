import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/provider/edit_profile.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/components/step_profile_image.dart';
import 'package:provider/provider.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  static const List<String> _conditions = [
    "Alzheimer's Disease",
    'Dementia',
    "Parkinson's Disease",
    'Visual Impairment',
    'Hearing Impairment',
    'Mobility Disorder',
    'Autism Spectrum',
    'Other',
  ];
  static const List<String> _relations = [
    'Son',
    'Daughter',
    'Spouse / Partner',
    'Parent',
    'Sibling',
    'Professional Caregiver',
    'Nurse',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<ProfileProvider>().user;
      if (user != null) {
        context.read<EditProfileProvider>().initProfile(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Consumer<EditProfileProvider>(
              builder: (context, provider, _) {
                final isCaregiver = provider.originalUser?.isCaregiver ?? false;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.y(1),
                      _buildPhotoSection(context, provider),
                      Spacing.y(3),
                      _buildSectionTitle('Personal Information'),
                      Spacing.y(1.5),
                      _buildLabel('Full Name'),
                      Spacing.y(0.6),
                      CustomTextField(
                        controller: provider.nameController,
                        hint: 'Full name',
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      Spacing.y(2),
                      _buildLabel('Date of Birth'),
                      Spacing.y(0.6),
                      GestureDetector(
                        onTap: () => provider.pickDateOfBirth(context),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: provider.dobController,
                            hint: 'DD/MM/YYYY',
                            prefixIcon: Icons.cake_outlined,
                            readOnly: true,
                          ),
                        ),
                      ),
                      Spacing.y(2),
                      _buildLabel('Phone Number'),
                      Spacing.y(0.6),
                      CustomTextField(
                        controller: provider.phoneController,
                        hint: 'e.g. +92 300 1234567',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      if (!isCaregiver) ...[
                        Spacing.y(3),
                        _buildSectionTitle('Medical Information'),
                        Spacing.y(1.5),
                        _buildLabel('Medical Condition'),
                        Spacing.y(0.6),
                        _DropdownField(
                          controller: provider.conditionController,
                          hint: 'Select condition',
                          icon: Icons.medical_information_outlined,
                          options: _conditions,
                        ),
                        Spacing.y(2),
                        _buildLabel('Blood Group'),
                        Spacing.y(0.6),
                        _DropdownField(
                          controller: provider.bloodGroupController,
                          hint: 'Select blood group',
                          icon: Icons.bloodtype_outlined,
                          options: _bloodGroups,
                        ),
                        Spacing.y(2),
                        _buildLabel('Emergency Contact'),
                        Spacing.y(0.6),
                        CustomTextField(
                          controller: provider.emergencyContactController,
                          hint: 'Emergency contact number',
                          prefixIcon: Icons.contact_phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                      if (isCaregiver) ...[
                        Spacing.y(3),
                        _buildSectionTitle('Caregiver Details'),
                        Spacing.y(1.5),
                        _buildLabel('Relation to Patient'),
                        Spacing.y(0.6),
                        _DropdownField(
                          controller: provider.relationController,
                          hint: 'Select relation',
                          icon: Icons.people_outline_rounded,
                          options: _relations,
                        ),
                      ],
                      Spacing.y(4),
                      CustomButton(
                        text: 'Save Changes',
                        isLoading: provider.isLoading,
                        prefixIcon: provider.isLoading
                            ? null
                            : Icon(
                                Icons.save_rounded,
                                color: Colors.white,
                                size: SizeConfig.widthMultiplier * 5,
                              ),
                        onTap: () => provider.save(
                          context,
                          onSuccess: (updated) =>
                              Navigator.pop(context, updated),
                        ),
                      ),
                      Spacing.y(3),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
            vertical: SizeConfig.heightMultiplier * 1.5,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: SizeConfig.widthMultiplier * 10,
                  height: SizeConfig.widthMultiplier * 10,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: SizeConfig.widthMultiplier * 4,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              AppText(
                'Edit Profile',
                size: 18,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(
    BuildContext context,
    EditProfileProvider provider,
  ) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => ImagePickerBottomSheet.show(
              context,
              onPickImage: (source) async =>
                  provider.pickPhoto(context, source),
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: SizeConfig.widthMultiplier * 28,
                  height: SizeConfig.widthMultiplier * 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(
                      color: provider.profileImage != null
                          ? AppColors.primary
                          : AppColors.border,
                      width: provider.profileImage != null ? 3 : 1.5,
                    ),
                    image: provider.profileImage != null
                        ? DecorationImage(
                            image: FileImage(provider.profileImage!),
                            fit: BoxFit.cover,
                          )
                        : (provider.originalUser?.profileImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    provider.originalUser!.profileImageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null),
                  ),
                  child:
                      (provider.profileImage == null &&
                          provider.originalUser?.profileImageUrl == null)
                      ? Icon(
                          Icons.person_rounded,
                          size: SizeConfig.widthMultiplier * 14,
                          color: AppColors.primary.withOpacity(0.5),
                        )
                      : null,
                ),
                Container(
                  width: SizeConfig.widthMultiplier * 8,
                  height: SizeConfig.widthMultiplier * 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: SizeConfig.widthMultiplier * 4,
                  ),
                ),
              ],
            ),
          ),
          Spacing.y(0.8),
          AppText('Tap to change photo', size: 12, color: AppColors.iconGrey),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: SizeConfig.widthMultiplier * 1,
          height: SizeConfig.heightMultiplier * 2.5,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 2.5),
        AppText(
          title,
          size: 15,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return AppText(
      text,
      size: 13,
      color: AppColors.textMedium,
      fontWeight: FontWeight.w600,
    );
  }
}

class _DropdownField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final List<String> options;

  const _DropdownField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          hint: hint,
          prefixIcon: icon,
          readOnly: true,
          suffixWidget: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 6,
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(
        options: options,
        selected: controller.text,
        onSelect: (val) {
          controller.text = val;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final List<String> options;
  final String selected;
  final Function(String) onSelect;

  const _PickerSheet({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(SizeConfig.widthMultiplier * 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          Container(
            width: SizeConfig.widthMultiplier * 9,
            height: SizeConfig.heightMultiplier * 0.5,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
          ...options.map((opt) {
            final isSelected = opt == selected;
            return GestureDetector(
              onTap: () => onSelect(opt),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 5,
                  vertical: SizeConfig.heightMultiplier * 1.6,
                ),
                color: isSelected
                    ? AppColors.primary.withOpacity(0.06)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        opt,
                        size: 14,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textDark,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_rounded,
                        color: AppColors.primary,
                        size: SizeConfig.widthMultiplier * 5,
                      ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
        ],
      ),
    );
  }
}
