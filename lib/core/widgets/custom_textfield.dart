import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../utils/size_config.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool autoFocus;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.suffixWidget,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.inputFormatters,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: SizeConfig.widthMultiplier * 1.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        readOnly: readOnly,
        autofocus: autoFocus,
        onTap: onTap,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.7,
          fontFamily: 'Poppins',
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.7,
            fontFamily: 'Poppins',
            color: AppColors.iconGrey,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: AppColors.iconGrey,
                  size: SizeConfig.widthMultiplier * 5,
                )
              : null,
          suffixIcon: suffixWidget,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
            vertical: SizeConfig.heightMultiplier * 1.8,
          ),
          isDense: true,
        ),
      ),
    );
  }
}

class AppFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? Function(String?)? validator;

  const AppFormTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
        fontSize: SizeConfig.textMultiplier * 1.6,
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.6,
          color: AppColors.iconGrey,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.widthMultiplier * 3,
                  right: SizeConfig.widthMultiplier * 2,
                ),
                child: Icon(
                  prefixIcon,
                  size: SizeConfig.widthMultiplier * 4.5,
                  color: AppColors.iconGrey,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3.5,
          vertical: SizeConfig.heightMultiplier * 1.6,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.alert, width: 1.5),
        ),
      ),
    );
  }
}

class AppOtpTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;

  const AppOtpTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier * 15,
      height: SizeConfig.widthMultiplier * 15,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: SizeConfig.widthMultiplier * 1.5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 2.5,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          isDense: true,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: onChanged,
      ),
    );
  }
}

class AppSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final bool showClear;

  const AppSearchTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onClear,
    this.showClear = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 5.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.6,
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
            Icons.search_rounded,
            size: SizeConfig.widthMultiplier * 5,
            color: AppColors.iconGrey,
          ),
          suffixIcon: showClear
              ? GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close_rounded,
                    size: SizeConfig.widthMultiplier * 4.5,
                    color: AppColors.iconGrey,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 1.5,
          ),
        ),
      ),
    );
  }
}

class AppBottomSheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;

  const AppBottomSheetTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLines == 1 ? SizeConfig.heightMultiplier * 6 : null,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: SizeConfig.textMultiplier * 1.7,
          fontFamily: 'Poppins',
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.7,
            fontFamily: 'Poppins',
            color: AppColors.iconGrey,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 5,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: SizeConfig.heightMultiplier * 1.7,
          ),
        ),
      ),
    );
  }
}

class AppEditProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const AppEditProfileTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
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
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3.5,
          vertical: SizeConfig.heightMultiplier * 1.7,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
