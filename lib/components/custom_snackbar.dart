import 'package:flutter/material.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message,
      {Color backgroundColor = AppColors.accentColor,
      Color textColor = Colors.white,
      Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      ),
    );
  }
}
