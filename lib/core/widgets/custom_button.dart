import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/size_config.dart';
import 'app_text.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isBordered;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.height,
    this.width,
    this.fontWeight,
    this.fontSize,
    this.prefixIcon,
    this.suffixIcon,
    this.isBordered = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = isEnabled
        ? (backgroundColor ?? AppColors.primary)
        : (backgroundColor ?? AppColors.primary).withOpacity(0.6);

    return GestureDetector(
      onTap: (isLoading || !isEnabled) ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width ?? double.infinity,
        height: height ?? SizeConfig.heightMultiplier * 6.5,
        decoration: BoxDecoration(
          color: isBordered ? Colors.white : effectiveBg,
          borderRadius: BorderRadius.circular(borderRadius ?? 14),
          border: isBordered
              ? Border.all(color: borderColor ?? AppColors.border, width: 1.5)
              : null,
          boxShadow: isBordered
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: SizeConfig.widthMultiplier * 2,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: SizeConfig.heightMultiplier * 2.5,
                  height: SizeConfig.heightMultiplier * 2.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isBordered ? AppColors.primary : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon!,
                    SizedBox(width: SizeConfig.widthMultiplier * 2),
                  ],
                  AppText(
                    text,
                    size: fontSize ?? 16,
                    color: isBordered
                        ? (textColor ?? AppColors.textDark)
                        : (textColor ?? Colors.white),
                    fontWeight: fontWeight ?? FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  if (suffixIcon != null) ...[
                    SizedBox(width: SizeConfig.widthMultiplier * 2),
                    suffixIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
