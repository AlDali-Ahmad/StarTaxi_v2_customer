import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tawsella_final/components/custom_botton.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final IconData icon; // معامل جديد لتحديد الأيقونة

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onCancel,
    required this.onConfirm,
    this.icon = Icons.warning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      content: Container(
        height: size.height / 3.2,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: onCancel,
              ),
            ),
            Icon(
              icon,
              size: 23,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 1.5,
              color: Colors.grey,
              width: size.width / 4,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Container(
                //   width: size.width / 3.3,
                //   height: (size.height / 10) / 2,
                //   child: InkWell(
                //     onTap: onCancel,
                //     child: Container(
                //       height: 10,
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(10),
                //         border: Border.all(
                //           color: Colors.blue,
                //           width: 2,
                //         ),
                //       ),
                //       child: Center(
                //         child: Text(
                //           cancelButtonText,
                //           style: const TextStyle(
                //             color: Colors.blue,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 38.h,
                  width: 120.w,
                  child: CustomButton(
                    border_color: Colors.orange,
                    textColor: Colors.orange,
                    background_color1: AppColors.nullColor,
                    background_color2: AppColors.nullColor,
                    onPressed: onCancel,
                    text: cancelButtonText,
                  ),
                ),
                SizedBox(
                  height: 38.h,
                  width: 120.w,
                  child: LoadingButtonWidget(
                    backgroundColor1: Colors.orange,
                    backgroundColor2: AppColors.orange,
                    borderColor: AppColors.nullColor,
                    onPressed: onConfirm,
                    text: confirmButtonText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
