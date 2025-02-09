import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/Pages/Requests/View/orderCarPage.dart';
import 'package:tawsella_final/Pages/Requests/View/timerorderCar.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';

import 'package:tawsella_final/utils/app_colors.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/bactawsilla.png'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250.h,
              decoration: const BoxDecoration(
                color: AppColors.textColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      'أين تريد الذهاب ؟ إطلب الآن',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    LoadingButtonWidget(
                        borderRadius: 20,
                        text: 'طلب تكسي',
                        onPressed: () {
                          Get.to(() => const OrderCarPage());
                        }),
                    SizedBox(height: 30.h),
                    LoadingButtonWidget(
                      text: 'إستئجار تكسي',
                      onPressed: () {
                        Get.to(TimerPage());
                      },
                      borderRadius: 20,
                      lodingColor: AppColors.textColor,
                      backgroundColor1: AppColors.nullColor,
                      backgroundColor2: AppColors.nullColor,
                      textColor: AppColors.white,
                      borderColor: AppColors.white,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
