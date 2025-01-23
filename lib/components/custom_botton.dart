import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? border_redios;
  final double fontSize;
  final Color textColor;
  final Color background_color1;
  final Color background_color2;
  final Color border_color;
  final FontWeight fontWeight;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height,
    this.border_redios = 20,
    this.width = double.infinity,
    this.fontSize = 16.0,
    this.textColor = AppColors.white,
    this.background_color1 = AppColors.blue2,
    this.background_color2 = AppColors.blue1,
    this.border_color = AppColors.blue2,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? 45.h,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [background_color1, background_color2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(border_redios!),
          border: Border.all(
            color: border_color,
            width: 5.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize.sp,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
