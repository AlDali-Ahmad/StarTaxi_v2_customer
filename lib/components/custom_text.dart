import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final Alignment alignment;
  final String fontFamily;

  const CustomText({
    this.text = '',
    this.fontSize = 16,
    this.color = AppColors.textColor,
    this.fontWeight = FontWeight.normal,
    this.alignment = Alignment.topLeft,
    this.fontFamily = 'Cairo',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        style: GoogleFonts.getFont(
          fontFamily, 
          textStyle: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
