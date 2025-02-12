import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_btn/loading_btn.dart';

// import 'package:nimah_app/themes/app_colors.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class LoadingButtonWidget extends StatefulWidget {
  final String text;
  final FutureOr<void> Function() onPressed;
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
    super.key,
    required this.text,
    required this.onPressed,
    this.height,
    this.width,
    this.borderRadius = 20.0,
    this.fontSize = 16.0,
    this.textColor = AppColors.white,
    this.lodingColor = AppColors.white,
    this.backgroundColor1 = AppColors.orange2,
    this.backgroundColor2 = AppColors.orange1,
    this.borderColor = AppColors.orange2,
    this.fontWeight = FontWeight.bold,
  });

  @override
  State<LoadingButtonWidget> createState() => _LoadingButtonWidgetState();
}

class _LoadingButtonWidgetState extends State<LoadingButtonWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: _isLoading,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          height: widget.height ?? 45.h,
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.backgroundColor1, widget.backgroundColor2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            border: Border.all(
              color: widget.borderColor,
              width: 2.0,
            ),
          ),
          child: LoadingBtn(
            roundLoadingShape: false,
            height: widget.height ?? 45.h,
            width: (widget.width ?? 200).w,
            borderRadius: widget.borderRadius!,
            color: Colors.transparent,
            loader: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.backgroundColor1, widget.backgroundColor2],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius!),
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(widget.lodingColor),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.backgroundColor1, widget.backgroundColor2],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius!),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                  ),
                ),
              ),
            ),
            onTap: (startLoading, stopLoading, btnState) async {
              if (btnState == ButtonState.idle) {
                startLoading();
                setState(() => _isLoading = true);
                await widget.onPressed();
                stopLoading();
                setState(() => _isLoading = false);
              }
            },
          ),
        ),
      ),
    );
  }
}


// class LoadingButtonWidget extends StatefulWidget {
//   final String text;
//   final Future<void> Function() onPressed; 
//   final double? height;
//   final double? width;
//   final double? borderRadius;
//   final double fontSize;
//   final Color textColor;
//   final Color backgroundColor1;
//   final Color backgroundColor2;
//   final Color borderColor;
//   final Color lodingColor;
//   final FontWeight fontWeight;

//   const LoadingButtonWidget({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.height,
//     this.width,
//     this.borderRadius = 10.0,
//     this.fontSize = 16.0,
//     this.textColor = AppColors.white,
//     this.lodingColor = AppColors.white,
//     this.backgroundColor1 = AppColors.orange2,
//     this.backgroundColor2 = AppColors.orange1,
//     this.borderColor = AppColors.orange2,
//     this.fontWeight = FontWeight.bold,
//   });

//   @override
//   _LoadingButtonWidgetState createState() => _LoadingButtonWidgetState();
// }

// class _LoadingButtonWidgetState extends State<LoadingButtonWidget> {
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: isLoading ? null : () async {
//         setState(() {
//           isLoading = true; 
//         });
//         try {
//           await widget.onPressed(); 
//         } finally {
//           setState(() {
//             isLoading = false;
//           });
//         }
//       },
//       child: Container(
//         height: widget.height ?? 45.h,
//         width: widget.width ?? double.infinity,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [widget.backgroundColor1, widget.backgroundColor2],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(widget.borderRadius!),
//           border: Border.all(
//             color: widget.borderColor,
//             width: 5.0,
//           ),
//         ),
//         child: LoadingBtn(
//           animate: false,
//           roundLoadingShape: false,
//           height: widget.height ?? 45.h,
//           width: (widget.width ?? 200).w,
//           borderRadius: widget.borderRadius!,
//           color: Colors.transparent,
//           loader: Container(
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [widget.backgroundColor1, widget.backgroundColor2],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(widget.borderRadius!),
//             ),
//             child: CircularProgressIndicator(
//               strokeWidth: 3.0,
//               strokeCap: StrokeCap.round,
//               valueColor: AlwaysStoppedAnimation<Color>(widget.lodingColor),
//             ),
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [widget.backgroundColor1, widget.backgroundColor2],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(widget.borderRadius!),
//             ),
//             child: CircularProgressIndicator(
//               strokeWidth: 3.0,
//               strokeCap: StrokeCap.round,
//               valueColor: AlwaysStoppedAnimation<Color>(widget.lodingColor),
//             ),
//           ),
//           onTap: null, 
//         ),
//       ),
//     );
//   }
// }
