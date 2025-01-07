// import 'package:flutter/material.dart';
// import 'package:tawsella_final/utils/app_colors.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final Color hintColor;
//   final Color iconColor;
//   final IconData? iconData;
//   final double fontSize;
//   final IconButton? suffixIcon;
//   final bool? obscureText;

//   const CustomTextField({
//     required this.controller,
//     this.hintText = '',
//     this.hintColor = Colors.black26,
//     this.iconColor = AppColors.iconColor,
//     this.iconData,
//     this.fontSize = 17.0,
//     this.suffixIcon,
//     this.obscureText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
//         filled: true,
//         fillColor: AppColors.textField_color,
//         border: InputBorder.none,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12.0),
//           borderSide: BorderSide.none,
//         ),
//         prefixIcon: Icon(
//           iconData,
//           color: iconColor,
//         ),
//         suffixIcon: suffixIcon,
//       ),
//     );
//   }
// }
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
  final bool isNumeric;
  final TextInputType? keyboardType;
  final Color fillColor;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.fillColor = AppColors.textField_color,
    this.hintColor = Colors.black26,
    this.iconColor = Colors.black,
    this.iconData,
    this.fontSize = 17.0,
    this.suffixIcon,
    this.obscureText,
    this.validator,
    this.isNumeric = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      keyboardType: isNumeric ? TextInputType.number : keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor, fontSize: fontSize),
        filled: true,
        fillColor: fillColor,
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          iconData,
          color: iconColor,
          size: 21,
        ),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 17.0),
      ),
      obscureText: obscureText ?? false,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
