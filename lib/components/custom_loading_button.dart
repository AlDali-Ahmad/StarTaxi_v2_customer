import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_btn/loading_btn.dart';
import '../utils/app_colors.dart';

class LoadingButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color borderColor;
  final Color lodingColor;
  final FontWeight fontWeight;

  const LoadingButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.borderRadius = 10.0,
    this.fontSize = 16.0,
    this.textColor = AppColors.white,
    this.lodingColor = AppColors.white,
    this.backgroundColor1 = AppColors.orange2,
    this.backgroundColor2 = AppColors.orange1,
    this.borderColor = AppColors.orange2,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: height ?? 45.h,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor1, backgroundColor2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(borderRadius!),
          border: Border.all(
            color: borderColor,
            width: 5.0,
          ),
        ),
        child: LoadingBtn(
          height: height ?? 45.h,
          width: (width ?? 200).w,
          borderRadius: borderRadius!,
          animate: false,
          color: Colors.transparent,
          roundLoadingShape: false,
          loader: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor1, backgroundColor2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            child:  CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(lodingColor),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor1, backgroundColor2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(borderRadius!),
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
          onTap: (startLoading, stopLoading, btnState) async {
            if (btnState == ButtonState.idle) {
              startLoading();
              await Future.delayed(const Duration(seconds: 1));
              onPressed();
              stopLoading();
            }
          },
        ),
      ),
    );
  }
}
