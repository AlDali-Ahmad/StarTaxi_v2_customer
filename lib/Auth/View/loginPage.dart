// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
// import 'package:tawsella_final/Auth/View/regesterPage.dart';
// import 'package:tawsella_final/Auth/View/verification_code.dart';
// import 'package:tawsella_final/Pages/bottombar.dart';
// import 'package:tawsella_final/components/customTextField.dart';
// import 'package:tawsella_final/components/custom_loading_button.dart';
// import 'package:tawsella_final/components/custom_snackbar.dart';
// import 'package:tawsella_final/utils/app_colors.dart';
// import '../../components/custom_text.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _showPassword = false;
//   var mail_code_verified_at;

//   Future<void> _getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       mail_code_verified_at = prefs.getString('mail_code_verified_at');
//       print('Token: $mail_code_verified_at');
//     });
//   }

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final AuthService _authService = AuthService();

//   Future<void> _login() async {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       CustomSnackbar.show(context, 'Please enter your email and password');
//       return;
//     }

//     final result = await _authService.loginUser(
//       emailController.text,
//       passwordController.text,
//     );

//     if (result != null && result.containsKey('error')) {
//       CustomSnackbar.show(context, result['error']);
//     } else {
//         Get.off(Bottombar());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset("assets/images/car1.png", height: 70.h),
//                     const CustomText(
//                       text: 'Login Page',
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.iconColor,
//                       alignment: Alignment.center,
//                     ),
//                     SizedBox(height: size.height / 30),
//                     CustomTextField(
//                       controller: emailController,
//                       hintText: 'Enter your Email',
//                       iconData: Icons.email,
//                     ),
//                     SizedBox(height: size.height / 30),
//                     TextField(
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         hintText: 'Enter your Password',
//                         hintStyle: TextStyle(color: AppColors.iconColor),
//                         prefixIcon:
//                             Icon(Icons.lock, color: AppColors.iconColor),
//                         filled: true,
//                         fillColor: AppColors.textField_color,
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _showPassword = !_showPassword;
//                             });
//                           },
//                           icon: Icon(
//                             _showPassword
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       obscureText: !_showPassword,
//                     ),
//                     SizedBox(height: size.height / 25),
//                     LoadingButtonWidget(
//                       text: 'Login',
//                       onPressed: _login,
//                     ),
//                     SizedBox(height: size.height / 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const CustomText(
//                           text: "Don't have an account?",
//                           color: AppColors.white,
//                           fontSize: 14,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => const RegisterPage());
//                           },
//                           child: const CustomText(
//                             text: 'Create an account',
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF8DD2C9),
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
import 'package:tawsella_final/Auth/View/regesterPage.dart';
import 'package:tawsella_final/Auth/View/verification_code.dart';
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import '../../components/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackbar.show(context, 'please_enter_email_and_password'.tr);
      return;
    }

    final result = await _authService.loginUser(
      emailController.text,
      passwordController.text,
    );

    if (result != null && result.containsKey('error')) {
      CustomSnackbar.show(context, result['error']);
    } else {
      Get.off(Bottombar());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/car1.png", height: 70.h),
                     CustomText(
                      text: 'login_page'.tr,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.iconColor,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: size.height / 30),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'enter_your_email'.tr,
                      iconData: Icons.email,
                    ),
                    SizedBox(height: size.height / 30),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'enter_your_password'.tr,
                        hintStyle: TextStyle(color: AppColors.iconColor),
                        prefixIcon:
                            Icon(Icons.lock, color: AppColors.iconColor),
                        filled: true,
                        fillColor: AppColors.textField_color,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: !_showPassword,
                    ),
                    SizedBox(height: size.height / 25),
                    LoadingButtonWidget(
                      text: 'login'.tr,
                      onPressed: _login,
                    ),
                    SizedBox(height: size.height / 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         CustomText(
                          text: "dont_have_account".tr,
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const RegisterPage());
                          },
                          child:  CustomText(
                            text: 'create_an_account'.tr,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8DD2C9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
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






















// import 'dart:convert';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawsella_final/Auth/View/regesterPage.dart';
// import 'package:tawsella_final/Pages/bottombar.dart';
// import 'package:tawsella_final/components/customTextField.dart';
// import 'package:tawsella_final/components/custom_loading_button.dart';
// import 'package:tawsella_final/components/custom_snackbar.dart';
// import 'package:tawsella_final/utils/app_colors.dart';

// import '../../components/custom_text.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   bool _showPassword = false;

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> loginUser() async {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       CustomSnackbar.show(
//         context,
//         'الرجاء إدخال البريد الإلكتروني وكلمة المرور',
//       );
//       return;
//     }

//     if (!_isValidEmail(emailController.text)) {
//       CustomSnackbar.show(
//         context,
//         'البريد الإلكتروني غير صالح',
//       );
//       return;
//     }

//     final Map<String, dynamic> data = {
//       'email': emailController.text,
//       'password': passwordController.text,
//     };

//     final Uri url = Uri.parse('${Url.url}api/login');

//     try {
//       final response = await http.post(
//         url,
//         body: jsonEncode(data),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final String token = responseData['data']['token'];
//         // ignore: non_constant_identifier_names
//         final String Id = responseData['data']['user']['id'];
//         final String currentEmail = responseData['data']['user']['email'];
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('token', token);
//         prefs.setString('Id', Id);
//         prefs.setString('email', currentEmail);
//         print(Id);
//         print(token);
//         print(currentEmail);
//         Get.off(() => const Bottombar());
//       } else if (response.statusCode == 422) {
//         CustomSnackbar.show(
//           context,
//           'خطأ في البريد الإلكتروني أو كلمة المرور'.tr,
//         );
//         final Map<String, dynamic> errorData = json.decode(response.body);
//         if (errorData['error'] != null) {
//           CustomSnackbar.show(
//             context,
//             'خطأ في البريد الإلكتروني أو كلمة المرور'.tr,
//           );
//         } else {
//           print('1حدث خطأ: ${response.body}');
//         }
//       } else {
//         print('2حدث خطأ: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('3حدث خطأ : $error');
//     }
//   }

//   bool _isValidEmail(String email) {
//     // التحقق من وجود الرمز "@" والنقطة "."
//     if (email.contains('@') && email.contains('.')) {
//       // التحقق من عدم وجود مسافات
//       if (!email.contains(' ')) {
//         // التحقق من عدم وجود حروف عربية
//         if (!RegExp(r'[ء-ي]').hasMatch(email)) {
//           return true;
//         }
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     // Get.lazyPut<AuthController>(() => AuthController());
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ClipRRect(
//                       // borderRadius: BorderRadius.circular(100),
//                       child: Image.asset(
//                         "assets/images/car1.png",
//                         fit: BoxFit.fill,
//                         height: 70.h,
//                         // width: 150.w,
//                       ),
//                     ),
//                     SizedBox(height: 20.h),
//                     const CustomText(
//                       text: 'Login Page',
//                       alignment: Alignment.center,
//                       fontSize: 25,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.iconColor,
//                     ),
//                     SizedBox(height: size.height / 30),
//                     // Email TextField
//                     CustomTextField(
//                       controller: emailController,
//                       hintText: 'Enter your Eamil',
//                       iconData: Icons.email,
//                       iconColor: AppColors.iconColor,
//                     ),
//                     SizedBox(height: size.height / 30),
//                     // Password TextField
//                     TextField(
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         hintStyle: TextStyle(color: Colors.black26),
//                         hintText: 'Enter your Password',
//                         prefixIcon: Icon(Icons.lock,color: AppColors.iconColor,),
//                         filled: true,
//                         fillColor: AppColors.textField_color,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _showPassword = !_showPassword;
//                             });
//                           },
//                           icon: Icon(
//                             _showPassword
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                                 color: AppColors.iconColor,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       obscureText: !_showPassword,
//                     ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     //Get.to(() => const RegisterPage());
//                     //   },
//                     //   child: const CustomText(
//                     //     text: 'هل نسيت كلمة المرور؟',
//                     //     alignment: Alignment.topRight,
//                     //     fontWeight: FontWeight.bold,
//                     //     color: Color(0xFF00AAA0),
//                     //   ),
//                     // ),
//                     SizedBox(height: size.height / 25),
//                     LoadingButtonWidget(
//                       text: 'Login',
//                       onPressed: () {
//                        loginUser();
//                       },
//                     ),
                    
//                     SizedBox(height: size.height / 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const CustomText(
//                           text: "Don't you have an account?",
//                           color: AppColors.white,
//                           fontSize: 14,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => const RegisterPage());
//                           },
//                           child: const CustomText(
//                             text: 'Create an account',
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF8DD2C9),
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
