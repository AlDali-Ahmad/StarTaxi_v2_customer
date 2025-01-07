import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class CustomPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomPasswordField({
    super.key,
    required this.controller,
    this.hintText = 'enter_your_password',
    this.validator,
  });

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_showPassword,
      decoration: InputDecoration(
        hintStyle:  TextStyle(color: AppColors.iconColor),
        hintText: widget.hintText.tr,
        prefixIcon:  Icon(
          Icons.lock,
          color: AppColors.iconColor,
          size: 16,
        ),
        filled: true,
        fillColor: AppColors.textField_color,
        contentPadding:  EdgeInsets.symmetric(vertical: 17.0),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: AppColors.iconColor,
            size: 16,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: widget.validator,
    );
  }
}
