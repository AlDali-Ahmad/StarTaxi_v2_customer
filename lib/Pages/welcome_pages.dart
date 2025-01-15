import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/auth/View/login_page.dart';
import 'package:tawsella_final/components/custom_botton.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class WelcomeScreens extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreens> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Map<String, dynamic>> splashData = [
    {
      "texts": [
        'welcome_taxi_service'.tr,
        'book_ride_anytime'.tr,
        'enjoy_service'.tr,
      ],
      "image": "assets/images/car1.png",
    },
    {
      "texts": [
        'safe_comfortable_service'.tr,
        'separate_services'.tr,
        'comfort_safety'.tr,
      ],
      "image": "assets/images/car2.png",
    },
    {
      "texts": [
        'book_now'.tr,
        'choose_destination'.tr,
        'complete_booking'.tr,
      ],
      "image": "assets/images/car3.png",
    },
  ];

  void _skip() {
    if (_currentPage < splashData.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Get.off(const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageController,
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: splashData.length,
            itemBuilder: (context, index) => SplashContent(
              image: splashData[index]["image"],
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 330.h),
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    SizedBox(height: 120.h),
                    Column(
                      children: [
                        for (var text in splashData[_currentPage]["texts"])
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 35),
                      child: CustomButton(
                        onPressed: () {
                          Get.off(const LoginPage());
                        },
                        text: 'get_started'.tr,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 35, bottom: 0),
                      child: CustomButton(
                        background_color1: AppColors.white,
                        background_color2: AppColors.white,
                        onPressed: _skip,
                        text: 'skip'.tr,
                        textColor: AppColors.orange2,
                        border_color: AppColors.orange2,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.orange1 : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.image,
  }) : super(key: key);
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.0, -0.4),
      child: Image.asset(
        height: 250.h,
        width: 250.w,
        image!,
        fit: BoxFit.contain,
      ),
    );
  }
}
