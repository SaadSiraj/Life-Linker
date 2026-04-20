import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/provider/add_person.dart';
import 'package:provider/provider.dart';

class AddPersonSaveButton extends StatelessWidget {
  final Function(KnownPerson saved) onSave;

  const AddPersonSaveButton({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddPersonProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: double.infinity,
          height: 54.v,
          child: ElevatedButton(
            onPressed: provider.isSaving
                ? null
                : () => provider.save(context, () {}),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: AppColors.primary.withOpacity(0.3),
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
                      Icon(
                        Icons.person_add_rounded,
                        color: Colors.white,
                        size: 20.h,
                      ),
                      SizedBox(width: 8.h),
                      AppText(
                        'Save Person',
                        size: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}