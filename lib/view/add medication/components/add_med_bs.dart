import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:provider/provider.dart';

class AddMedBottomSheet extends StatelessWidget {
  const AddMedBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.h,
                    height: 4.v,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Gap.v(16),
                AppText(
                  'Add Medication',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                Gap.v(16),
                _buildInput('Medication Name', provider.nameController, Icons.medication_rounded),
                Gap.v(12),
                _buildInput('Dosage (e.g. 10mg)', provider.dosageController, Icons.scale_rounded),
                Gap.v(12),
                _buildFrequencySelector(provider),
                Gap.v(12),
                _buildTimePicker(context, provider),
                Gap.v(20),
                SizedBox(
                  width: double.infinity,
                  height: 52.v,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.saveMedication();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: AppText(
                      'Save Medication',
                      size: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gap.v(8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput(String hint, TextEditingController ctrl, IconData icon) {
    return Container(
      height: 50.v,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: ctrl,
        style: TextStyle(
          fontSize: 14.fSize,
          fontFamily: 'Poppins',
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.fSize,
            fontFamily: 'Poppins',
            color: AppColors.iconGrey,
          ),
          prefixIcon: Icon(icon, color: AppColors.iconGrey, size: 20.h),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.v),
        ),
      ),
    );
  }

  Widget _buildFrequencySelector(MedicationProvider provider) {
    final options = ['Daily', 'Weekly', 'As needed'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Frequency', size: 13, color: AppColors.iconGrey, fontWeight: FontWeight.w500),
        Gap.v(8),
        Row(
          children: options.map((o) {
            final isSelected = provider.selectedFrequency == o;
            return GestureDetector(
              onTap: () => provider.setFrequency(o),
              child: Container(
                margin: EdgeInsets.only(right: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.v),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: AppText(
                  o,
                  size: 12,
                  color: isSelected ? Colors.white : AppColors.textDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, MedicationProvider provider) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: provider.selectedTime,
        );
        if (picked != null) provider.setTime(picked);
      },
      child: Container(
        height: 50.v,
        padding: EdgeInsets.symmetric(horizontal: 14.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, color: AppColors.iconGrey, size: 20.h),
            SizedBox(width: 10.h),
            Expanded(
              child: AppText(
                provider.selectedTime.format(context),
                size: 14,
                color: AppColors.textDark,
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppColors.iconGrey, size: 20.h),
          ],
        ),
      ),
    );
  }
}