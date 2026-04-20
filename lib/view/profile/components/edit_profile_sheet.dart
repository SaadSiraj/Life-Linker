import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:provider/provider.dart';

class EditProfileSheet extends StatelessWidget {
  const EditProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              SizeConfig.widthMultiplier * 5,
              SizeConfig.heightMultiplier * 2.5,
              SizeConfig.widthMultiplier * 5,
              SizeConfig.heightMultiplier * 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.heightMultiplier * 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  'Edit Profile',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                _sectionLabel('Caregiver'),
                SizedBox(height: SizeConfig.heightMultiplier * 1.2),
                _buildField(
                  'Your Name',
                  provider.caregiverNameController,
                  Icons.person_outline_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                _buildField(
                  'Your Phone',
                  provider.caregiverPhoneController,
                  Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2.5),
                _sectionLabel('Patient'),
                SizedBox(height: SizeConfig.heightMultiplier * 1.2),
                _buildField(
                  'Patient Name',
                  provider.patientNameController,
                  Icons.elderly_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                _buildField(
                  'Condition',
                  provider.patientConditionController,
                  Icons.medical_information_outlined,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                _buildField(
                  'Emergency Contact',
                  provider.emergencyController,
                  Icons.contact_phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 3.5),
                CustomButton(
                  text: 'Save Changes',
                  onTap: () {
                    Navigator.pop(context);
                    provider.saveProfile(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return AppText(
      text,
      size: 12,
      color: AppColors.iconGrey,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  Widget _buildField(
    String hint,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: SizeConfig.textMultiplier * 1.7,
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.6,
          color: AppColors.iconGrey,
        ),
        prefixIcon: Icon(
          icon,
          size: SizeConfig.widthMultiplier * 4.5,
          color: AppColors.iconGrey,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3.5,
          vertical: SizeConfig.heightMultiplier * 1.7,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}