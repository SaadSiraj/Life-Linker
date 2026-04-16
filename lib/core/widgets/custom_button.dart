import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.isBorder = false,
    this.isEnabled = false,
    this.isLoading = false,
    required this.text,
    this.radius,
    required this.onTap,
    this.fontWeight,
    this.fontSize,
    this.height,
    this.width,
    this.fontColor,
    this.buttonColor,
    this.suffixIcon,
    this.icon,
  });
  final bool isBorder;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool isEnabled;
  final bool isLoading;
  final String text;
  final VoidCallback onTap;
  final double? radius;
  final double? fontSize;
  final Color? fontColor;
  final Color? buttonColor;
  final FontWeight? fontWeight;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ZoomTapAnimation(
      onTap: isLoading ? () {} : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: width ?? SizeConfig.widthMultiplier * 100,
        height: height ?? SizeConfig.heightMultiplier * 6,
        decoration: BoxDecoration(
          border: isBorder ? Border.all(color: Colors.grey.shade200) : null,
          color: isEnabled
              ? buttonColor ?? AppColors.primary
              : buttonColor ?? AppColors.iconGrey,
          borderRadius: BorderRadius.circular(radius ?? 8),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: SizeConfig.heightMultiplier * 2.8,
                  height: SizeConfig.heightMultiplier * 2.8,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      fontColor ?? Colors.white,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Padding(
                      padding: EdgeInsets.only(
                        right: SizeConfig.widthMultiplier * 2,
                      ),
                      child: icon!,
                    ),
                  Text(
                    text,
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: fontWeight ?? FontWeight.w600,
                      fontSize: fontSize ?? SizeConfig.textMultiplier * 2,
                      color: fontColor ?? Colors.white,
                    ),
                  ),
                  if (suffixIcon != null)
                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 2,
                      ),
                      child: suffixIcon!,
                    ),
                ],
              ),
      ),
    );
  }
}
