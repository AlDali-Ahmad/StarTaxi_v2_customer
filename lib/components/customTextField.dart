import 'package:flutter/material.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color hintColor;
  final Color iconColor;
  final IconData? iconData;
  final double fontSize;
  final IconButton? suffixIcon;
  final bool? obscureText;

  const CustomTextField({
    required this.controller,
    this.hintText = '',
    this.hintColor = Colors.black26,
    this.iconColor = AppColors.iconColor,
    this.iconData,
    this.fontSize = 17.0,
    this.suffixIcon,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
        filled: true,
        fillColor: AppColors.textField_color,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          iconData,
          color: iconColor,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
