import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class AddMedicationHeader extends StatelessWidget {
  const AddMedicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 8.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary, size: 18.h),
            ),
          ),
          SizedBox(width: 10.h),
          AppText(
            'Add Medication',
            size: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}