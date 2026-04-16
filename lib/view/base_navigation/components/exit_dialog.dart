import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ExitDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
              decoration: BoxDecoration(
                color: AppColors.alert.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                color: AppColors.alert,
                size: SizeConfig.widthMultiplier * 12,
              ),
            ),
            Spacing.y(2.5),
            AppText(
              'Exit LifeLinker',
              size: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            Spacing.y(1.5),
            AppText(
              'Are you sure you want to exit the app?',
              size: 14,
              color: AppColors.iconGrey,
              align: TextAlign.center,
            ),
            Spacing.y(3),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: AppText(
                      'Cancel',
                      size: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.iconGrey,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 3),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.alert,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: AppText(
                      'Exit',
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}