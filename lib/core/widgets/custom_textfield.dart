import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.label,
    required this.controller,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
    this.isPassword,
    this.suffixWidget,
    this.prefixWidget,
    this.autoFocus = false,
    this.onTap,
    this.cursorColor,
    this.hideHintText = false,
    this.maxLines = 1,
    this.width,
    this.hintText,
    this.backgroundColor = Colors.transparent,
    this.floatingLable,
    this.readOnly = false,
  });
  final String? label;
  final VoidCallback? onTap;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final Widget? suffixWidget;
  final Widget? prefixWidget;

  final bool autoFocus;
  final Color? cursorColor;
  final int maxLines;
  final bool hideHintText;
  final double? width;
  final String? hintText;
  final Color? backgroundColor;
  final FloatingLabelBehavior? floatingLable;
  final bool? readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: GestureDetector(
        onTap: widget.onTap,
        child: TextField(
          obscureText: widget.isPassword == true,
          controller: widget.controller,
          maxLines: widget.maxLines,
          cursorColor: widget.cursorColor,
          autofocus: widget.autoFocus,
          enabled: widget.onTap == null,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly ?? false,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.6,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.backgroundColor ?? Colors.transparent,
            label: widget.label != null ? Text(widget.label!) : null,
            alignLabelWithHint: true,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelStyle: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.textMultiplier * 1.5,
            ),
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.textMultiplier * 1.5,
            ),
            hintText: widget.hideHintText
                ? null
                : widget.hintText ?? widget.label,

            // suffixIconConstraints: BoxConstraints(
            //   maxWidth: SizeConfig.widthMultiplier * 12,
            // ),
            suffixIcon: widget.suffixWidget,
            prefix: widget.prefixWidget,
            floatingLabelBehavior:
                widget.floatingLable ?? FloatingLabelBehavior.always,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade400,
              fontSize: SizeConfig.textMultiplier * 1.5,
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 1.5,
              horizontal: SizeConfig.widthMultiplier * 3,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.black800),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.unFocusGreyClr),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.unFocusGreyClr),
            ),
          ),
        ),
      ),
    );
  }
}
