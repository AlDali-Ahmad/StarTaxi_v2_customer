// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
// import 'package:tawsella_final/Auth/View/EditProfilePage.dart';
// import 'package:tawsella_final/Auth/View/loginPage.dart';
// import 'package:tawsella_final/components/custom_botton.dart';
// import 'package:tawsella_final/components/custom_loading_button.dart';
// import 'package:tawsella_final/components/custom_text.dart';
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:tawsella_final/utils/url.dart';

// class UserInfoPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.BackgroundColor,
//         title: const Text(
//           'User Profile Page',
//           style: TextStyle(color: Colors.amber),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
//         ),
//       ),
//       body: Center(
//         child: FutureBuilder<Map<String, dynamic>>(
//           future: AuthService.getUserData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Column(
//                 children: [
//                   SizedBox(
//                     height: size.height / 6,
//                   ),
//                   const CustomText(
//                     text: 'أعد تسجيل الدخول او انشئ حساب جديد ',
//                     alignment: Alignment.center,
//                     color: Color.fromARGB(255, 27, 3, 79),
//                   ),
//                   SizedBox(
//                     height: size.height / 6,
//                   ),
//                   Center(
//                     child: SizedBox(
//                       height: size.height / 15,
//                       width: 200,
//                       child: CustomButton(
//                           onPressed: () {
//                             Get.off(() => const LoginPage());
//                           },
//                           text: 'تسجيل الدخول'),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               final userData = snapshot.data!['data'];

//               return Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(1.0),
//                           child: SizedBox(
//                             width: size.width / 1.8,
//                             height: size.height / 4,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(100),
//                               child: Image.network(
//                                 userData['avatar'] != null &&
//                                         userData['avatar'].isNotEmpty
//                                     ? '${Url.url}${userData['avatar']}'
//                                     : 'assets/images/car1.png', 
//                                 height: 110.h,
//                                 width: 120.w,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Image.asset(
//                                     'assets/images/car1.png',
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                         CustomText(text: 'Full Name:'),
//                         SizedBox(height: 3.h),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelStyle: const TextStyle(
//                               color: Colors.black,
//                             ),
//                             prefixIcon: const Icon(Icons.person),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             filled: true,
//                             fillColor: AppColors.textField_color,
//                           ),
//                           initialValue: userData['name'],
//                           readOnly: true,
//                         ),
//                         const SizedBox(height: 20),
//                         CustomText(text: 'Phone Number:'),
//                         SizedBox(height: 3.h),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelStyle: const TextStyle(
//                               color: Colors.black,
//                             ),
//                             prefixIcon: const Icon(Icons.phone),
//                             filled: true,
//                             fillColor: AppColors.textField_color,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                           ),
//                           initialValue: userData['phone_number'] ?? 'N/A',
//                           readOnly: true,
//                         ),
//                         const SizedBox(height: 20),
//                         CustomText(text: 'Your Email:'),
//                         SizedBox(height: 3.h),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelStyle: const TextStyle(
//                               color: Colors.black,
//                             ),
//                             filled: true,
//                             fillColor: AppColors.textField_color,
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                           ),
//                           initialValue: userData['email'],
//                           readOnly: true,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     LoadingButtonWidget(
//                       onPressed: () {
//                         Get.to(() => EditProfilePage(userId: '${userData['id']}'));
//                       },
//                       text: 'Update User Info',
//                     ),
//                     const SizedBox(height: 20),
                    
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
import 'package:tawsella_final/Auth/View/EditProfilePage.dart';
import 'package:tawsella_final/Auth/View/loginPage.dart';
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
          'userProfilePage'.tr,  // استخدام الترجمة
          style: TextStyle(color: Colors.amber),
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
                  const CustomText(
                    text: 'loginPrompt',  // استخدام الترجمة
                    alignment: Alignment.center,
                    color: Color.fromARGB(255, 27, 3, 79),
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
                          text: 'login'.tr),  // استخدام الترجمة
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
                        CustomText(text: 'fullName'.tr),  // استخدام الترجمة
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
                        CustomText(text: 'phoneNumber'.tr),  // استخدام الترجمة
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
                        CustomText(text: 'yourEmail'.tr),  // استخدام الترجمة
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
                      text: 'updateUserInfo'.tr,  // استخدام الترجمة
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




































// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:tawsella_final/Auth/View/EditProfilePage.dart';
// import 'package:tawsella_final/Auth/View/loginPage.dart';
// import 'package:tawsella_final/Pages/splash_screen.dart';
// import 'package:tawsella_final/components/custom_botton.dart';
// import 'package:tawsella_final/components/custom_loading_button.dart';
// import 'package:tawsella_final/components/custom_text.dart';
// import 'package:tawsella_final/utils/app_colors.dart';

// class UserInfo extends StatelessWidget {
//   Future<String> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token') ?? '';
//   }

//   Future<Map<String, dynamic>> getUserData() async {
//     final Uri url = Uri.parse('${Url.url}api/profile/my-profile');
//     String token = await _getToken();
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to load user data: ${response.statusCode}');
//       }
//     } catch (error) {
//       throw Exception('Failed to load user data: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       //backgroundColor: Color.fromARGB(255, 219, 236, 239),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'User Profile',
//           style: TextStyle(
//             color: AppColors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: AppColors.BackgroundColor,
//       ),

//       body: Center(
//         child: FutureBuilder<Map<String, dynamic>>(
//           future: getUserData(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Column(
//                 children: [
//                   SizedBox(
//                     height: size.height / 6,
//                   ),
//                   const CustomText(
//                     text: 'أعد تسجيل الدخول او انشئ حساب جديد ',
//                     alignment: Alignment.center,
//                     color: Color.fromARGB(255, 27, 3, 79),
//                   ),
//                   SizedBox(
//                     height: size.height / 6,
//                   ),
//                   Center(
//                     child: SizedBox(
//                       height: size.height / 15,
//                       width: 200,
//                       child: CustomButton(
//                           onPressed: () {
//                             Get.off(() => const LoginPage());
//                           },
//                           text: 'تسجيل الدخول'),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               final userData = snapshot.data!['data'];

//               return Padding(
//                 padding: const EdgeInsets.all(30.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(1.0),
//                           child: SizedBox(
//                             width: size.width / 1.8,
//                             height: size.height / 4,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(100),
//                               child: ClipRRect(
//                           borderRadius: BorderRadius.circular(80),
//                           child: Image.network(
//                             '',
//                             height: 110.h,
//                             width: 120.w,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               print('Error loading image: $error');
//                               return Image.asset(
//                                 'assets/images/car1.png',
//                               );
//                             },
//                           ),
//                         ),
//                             ),
//                           ),
//                         ),
//                         CustomText(text: 'Full Name:'),
//                         SizedBox(height: 3.h),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelStyle: TextStyle(
//                               color: Colors.black, 
//                             ),
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             filled: true, 
//                             fillColor:
//                                 AppColors.textField_color,
//                           ),
                          
//                           initialValue: userData?['name'],
//                           readOnly: true,
//                         ),
//                         const SizedBox(height: 20),
//                         CustomText(text: 'Phone Number:'),
//                         SizedBox(height: 3.h),
//                         TextFormField(
                          
//                           decoration: InputDecoration(
//                             labelStyle: TextStyle(
//                               color: Colors.black, 
//                             ),
//                             prefixIcon: const Icon(Icons.phone),
//                             filled: true,
//                             fillColor: AppColors.textField_color,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                           ),
                        
//                           initialValue: userData?['phoneNumber'],
//                           readOnly: true,
//                         ),
//                         const SizedBox(height: 20),
//                         CustomText(text: 'Your Email:'),
//                         SizedBox(height: 3.h),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelStyle: TextStyle(
//                               color: Colors.black, 
//                             ),
//                             filled: true,
//                             fillColor: AppColors.textField_color,
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                           ),
//                           initialValue: userData?['email'],
//                           readOnly: true,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     LoadingButtonWidget(
//                       onPressed: () {
//                         Get.to(
//                             () => EditProfilePage(userId: '${userData['id']}'));
//                       },
//                       text: 'Update User Info',
//                       // width: size.width / 2.5,
//                     )
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// Future<String> _getToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token') ?? '';
// }

// Future<void> logout() async {
//   final String apiUrl = '${Url.url}api/logout';
//   String token = await _getToken();
//   try {
//     // إلغاء تسجيل الدخول في الخادم
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.remove('token');
//       print('تم تسجيل الخروج بنجاح');
//       Get.off(() => const SplashScreen());
//     } else {
//       throw Exception('فشل تسجيل الخروج: ${response.statusCode}');
//     }
//   } catch (error) {
//     throw Exception('فشل تسجيل الخروج: $error');
//   }
// }
// /*

// Container(
//                 height: size.height / 2,
//                 width: size.width / 1.2,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 4, 
//                       blurRadius: 7,
//                       offset: Offset(0, 3), 
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.all(1),
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundImage: AssetImage("images/logo.jpg"),
//                         ),
//                       ),
//                     ),
//                     Text(
//                       'الاسم : ${userData['name']}',
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'الايميل : ${userData['email']}',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       'رقم الجوال: ${userData['phoneNumber']}',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     SizedBox(
//                       height: 35,
//                     ),
//                     CustomButton(
//                         width: size.width / 2.2,
//                         onPressed: () {
//                           Get.to(() =>
//                               EditProfilePage(userId: '${userData['id']}'));
//                         },
//                         text: 'تعديل البيانات'),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         logout();
//                       },
//                       child: const Text('تسجيل الخروج'),
//                     ),
//                   ],
//                 ),
//               );
//  */
