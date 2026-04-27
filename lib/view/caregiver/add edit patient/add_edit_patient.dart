import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/add_edit_patient.dart';
import 'package:lifelinker/view/common/onboarding/signup%20flow/components/step_profile_image.dart';
import 'package:provider/provider.dart';

class AddEditPatientView extends StatefulWidget {
  final UserModel? existingPatient;
  const AddEditPatientView({super.key, this.existingPatient});

  @override
  State<AddEditPatientView> createState() => _AddEditPatientViewState();
}

class _AddEditPatientViewState extends State<AddEditPatientView> {
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
      final provider = context.read<AddEditPatientProvider>();
      if (widget.existingPatient != null) {
        provider.initForEdit(widget.existingPatient!);
      } else {
        provider.initForAdd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingPatient != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, isEdit),
          Expanded(
            child: Consumer<AddEditPatientProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.heightMultiplier * 1),

                      // ── Photo ─────────────────────────────────────────────
                      _buildPhotoSection(context, provider),
                      SizedBox(height: SizeConfig.heightMultiplier * 3),

                      // ── Personal Info ─────────────────────────────────────
                      _buildSectionTitle('Personal Information'),
                      SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                      _buildLabel('Full Name *'),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                      CustomTextField(
                        controller: provider.nameController,
                        hint: 'e.g. John Doe',
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      _buildLabel('Date of Birth'),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.6),
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
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      _buildLabel('Phone Number'),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                      CustomTextField(
                        controller: provider.phoneController,
                        hint: 'e.g. +92 300 1234567',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 3),

                      // ── Medical Info ──────────────────────────────────────
                      _buildSectionTitle('Medical Information'),
                      SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                      _buildLabel('Medical Condition *'),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                      _DropdownField(
                        controller: provider.conditionController,
                        hint: 'Select condition',
                        icon: Icons.medical_information_outlined,
                        options: _conditions,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      _buildLabel('Blood Group *'),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                      _DropdownField(
                        controller: provider.bloodGroupController,
                        hint: 'Select blood group',
                        icon: Icons.bloodtype_outlined,
                        options: _bloodGroups,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      _buildLabel('Emergency Contact *'),
                      SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                      CustomTextField(
                        controller: provider.emergencyContactController,
                        hint: 'e.g. +92 300 1234567',
                        prefixIcon: Icons.contact_phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),

                      // ── Login Credentials (Add mode only) ─────────────────
                      if (!isEdit) ...[
                        SizedBox(height: SizeConfig.heightMultiplier * 3),
                        _buildSectionTitle('Login Credentials'),
                        SizedBox(height: SizeConfig.heightMultiplier * 0.8),
                        _buildCredentialsInfoBanner(),
                        SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                        _buildLabel('Email Address *'),
                        SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                        CustomTextField(
                          controller: provider.emailController,
                          hint: 'patient@example.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                        _buildLabel('Password *'),
                        SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                        CustomTextField(
                          controller: provider.passwordController,
                          hint: 'Min. 6 characters',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: provider.obscurePassword,
                          suffixWidget: IconButton(
                            icon: Icon(
                              provider.obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.iconGrey,
                              size: SizeConfig.widthMultiplier * 5,
                            ),
                            onPressed: provider.toggleObscurePassword,
                          ),
                        ),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                        _buildLabel('Confirm Password *'),
                        SizedBox(height: SizeConfig.heightMultiplier * 0.6),
                        CustomTextField(
                          controller: provider.confirmPasswordController,
                          hint: 'Re-enter password',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: provider.obscureConfirm,
                          suffixWidget: IconButton(
                            icon: Icon(
                              provider.obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.iconGrey,
                              size: SizeConfig.widthMultiplier * 5,
                            ),
                            onPressed: provider.toggleObscureConfirm,
                          ),
                        ),
                      ],

                      SizedBox(height: SizeConfig.heightMultiplier * 4),
                      CustomButton(
                        text: isEdit ? 'Update Patient' : 'Add Patient',
                        isLoading: provider.isLoading,
                        prefixIcon: provider.isLoading
                            ? null
                            : Icon(
                                isEdit
                                    ? Icons.save_rounded
                                    : Icons.person_add_rounded,
                                color: Colors.white,
                                size: SizeConfig.widthMultiplier * 5,
                              ),
                        onTap: () => provider.save(
                          context,
                          onSuccess: (patient, isEditResult) =>
                              Navigator.pop(context, patient),
                        ),
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 3),
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

  Widget _buildCredentialsInfoBanner() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3.5),
      decoration: BoxDecoration(
        color: AppColors.blueLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: SizeConfig.widthMultiplier * 5,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2.5),
          Expanded(
            child: AppText(
              'These credentials will be used by the patient to log in to the app on their own device.',
              size: 12,
              color: AppColors.textMedium,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isEdit) {
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
                isEdit ? 'Edit Patient' : 'Add Patient',
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
    AddEditPatientProvider provider,
  ) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => ImagePickerBottomSheet.show(
              context,
              onPickImage: (source) async {
                await provider.pickPhoto(context, source);
              },
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
                        : (provider.existingPatient?.profileImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    provider.existingPatient!.profileImageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null),
                  ),
                  child:
                      (provider.profileImage == null &&
                          provider.existingPatient?.profileImageUrl == null)
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
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText('Tap to add photo', size: 12, color: AppColors.iconGrey),
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

// ── Dropdown Field ─────────────────────────────────────────────────────────────

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
