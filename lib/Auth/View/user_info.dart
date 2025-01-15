import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/auth/Controller/auth_controller.dart';
import 'package:tawsella_final/auth/View/edit_profile_page.dart';
import 'package:tawsella_final/auth/View/login_page.dart';
import 'package:tawsella_final/components/custom_botton.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        title: Text(
          'userProfilePage'.tr, 
          style: const TextStyle(color: Colors.amber),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: AuthService.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  SizedBox(
                    height: size.height / 6,
                  ),
                  CustomText(
                    text: 'loginPrompt'.tr,
                    alignment: Alignment.center,
                    color: const Color.fromARGB(255, 27, 3, 79),
                  ),
                  SizedBox(
                    height: size.height / 6,
                  ),
                  Center(
                    child: SizedBox(
                      height: size.height / 15,
                      width: 200,
                      child: CustomButton(
                          onPressed: () {
                            Get.off(() => const LoginPage());
                          },
                          text: 'login'.tr),
                    ),
                  ),
                ],
              );
            } else {
              final userData = snapshot.data!['data'];

              return Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(
                            width: size.width / 1.8,
                            height: size.height / 4,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userData['avatar'] != null &&
                                        userData['avatar'].isNotEmpty
                                    ? '${Url.url}${userData['avatar']}'
                                    : 'assets/images/car1.png', 
                                height: 110.h,
                                width: 120.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/car1.png',
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        CustomText(text: 'fullName'.tr),
                        SizedBox(height: 3.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            filled: true,
                            fillColor: AppColors.textField_color,
                          ),
                          initialValue: userData['name'],
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        CustomText(text: 'phoneNumber'.tr), 
                        SizedBox(height: 3.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            prefixIcon: const Icon(Icons.phone),
                            filled: true,
                            fillColor: AppColors.textField_color,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          initialValue: userData['phone_number'] ?? 'N/A',
                          readOnly: true,
                        ),
                        const SizedBox(height: 20),
                        CustomText(text: 'yourEmail'.tr),
                        SizedBox(height: 3.h),
                        TextFormField(
                          decoration: InputDecoration(
                            labelStyle: const TextStyle(
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: AppColors.textField_color,
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          initialValue: userData['email'],
                          readOnly: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    LoadingButtonWidget(
                      onPressed: () {
                        Get.to(() => EditProfilePage(userId: '${userData['id']}'));
                      },
                      text: 'updateUserInfo'.tr,
                    ),
                    const SizedBox(height: 20),
                    
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
