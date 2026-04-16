import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showCustomSnackbar(BuildContext context, bool isError, String text) {
  showTopSnackBar(
    Overlay.of(context),
    Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 4,
        vertical: SizeConfig.heightMultiplier * 1.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.black900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_rounded : Icons.check_circle_rounded,
            color: isError ? AppColors.danger : AppColors.success,
          ),
          Spacing.x(2),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
