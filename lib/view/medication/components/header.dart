import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class MedicationHeader extends StatelessWidget {
  const MedicationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 12.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              //   Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const AddMedicationView()),
              // );
            },
            child: Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 22.h,
              ),
            ),
          ),
          SizedBox(width: 10.h),
          AppText(
            'Medication List',
            size: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
