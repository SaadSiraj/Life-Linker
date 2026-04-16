import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';

import '../constants/app_colors.dart';
import '../utils/size_config.dart';
import 'app_text.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final Color? confirmColor;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.confirmColor,
    this.isDestructive = false,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmLabel,
    required VoidCallback onConfirm,
    Color? confirmColor,
    bool isDestructive = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        onConfirm: onConfirm,
        confirmColor: confirmColor,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color =
        confirmColor ?? (isDestructive ? AppColors.alert : AppColors.primary);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: AppText(
        title,
        size: 16,
        color: AppColors.textDark,
        fontWeight: FontWeight.w700,
      ),
      content: AppText(message, size: 13, color: AppColors.iconGrey),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: AppText(
            'Cancel',
            size: 13,
            color: AppColors.iconGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomButton(
          text: confirmLabel,
          onTap: () {
            Navigator.pop(context);
            onConfirm();
          },
          backgroundColor: color,
          height: SizeConfig.heightMultiplier * 4.5,
          width: SizeConfig.widthMultiplier * 28,
          borderRadius: 10,
          fontSize: 13,
        ),
      ],
    );
  }
}
