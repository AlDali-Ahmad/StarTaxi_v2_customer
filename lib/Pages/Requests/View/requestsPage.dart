import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/Pages/Requests/View/order_car_page.dart';
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
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bactawsilla.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                       'Select the type of service you want :'.tr,
                       style: TextStyle(fontSize: 16.sp,
                      color: Colors.yellow,),
                      
                    ),
                    SizedBox(height: 40.h),
                    LoadingButtonWidget(
                        text: 'Request a taxi'.tr,
                        onPressed: () {
                          Get.to(() => OrderCarPage());
                        }),
                    SizedBox(height: 30.h),
                    LoadingButtonWidget(
                      text: 'Rent a car'.tr,
                      onPressed: () {
                        Get.to(TimerPage());
                      },
                      lodingColor: AppColors.textColor,
                      backgroundColor1: AppColors.white,
                      backgroundColor2: AppColors.white,
                      textColor: AppColors.orange2,
                      borderColor: AppColors.orange2,
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
