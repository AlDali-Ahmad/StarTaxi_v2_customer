// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
// import 'package:tawsella_final/Auth/View/loginPage.dart';
// import 'package:tawsella_final/Pages/bottombar.dart';
// import 'package:tawsella_final/components/customTextField.dart';
// import 'package:tawsella_final/components/custom_botton.dart';
// import 'package:tawsella_final/components/custom_loading_button.dart';
// import 'package:tawsella_final/components/custom_snackbar.dart';
// import 'package:tawsella_final/components/custom_text.dart';
// import 'package:tawsella_final/utils/app_colors.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final AuthService _authService = AuthService();
//   bool _showPassword = false;
//   bool _showPassword2 = false;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController passwordConfirmationController =
//       TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();

//   Future<void> registerUser() async {
//     if (nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         passwordConfirmationController.text.isEmpty ||
//         phoneNumberController.text.isEmpty) {
//       CustomSnackbar.show(context, 'الرجاء ملء جميع الحقول');
//       return;
//     }

//     if (passwordController.text.length < 8) {
//       CustomSnackbar.show(context, 'يجب أن تكون كلمة المرور على الأقل 8 أحرف');
//       return;
//     }

//     if (passwordController.text != passwordConfirmationController.text) {
//       CustomSnackbar.show(
//           context, 'كلمة المرور وتأكيد كلمة المرور غير متطابقين');
//       return;
//     }

//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//         .hasMatch(emailController.text)) {
//       CustomSnackbar.show(context, 'الرجاء إدخال عنوان بريد إلكتروني صالح');
//       return;
//     }

//     if (!phoneNumberController.text.startsWith('+')) {
//       CustomSnackbar.show(context, 'يجب أن يبدأ رقم الهاتف بـ "+"');
//       return;
//     }

//     final response = await _authService.registerUser(
//       name: nameController.text,
//       email: emailController.text,
//       password: passwordController.text,
//       passwordConfirmation: passwordConfirmationController.text,
//       phoneNumber: phoneNumberController.text,
//     );

//     if (response != null && response.containsKey('error')) {
//       CustomSnackbar.show(context, response['error']);
//     } else {
//       CustomSnackbar.show(context, 'تم إنشاء الحساب بنجاح');
//       Get.off(() => const Bottombar());
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
//                     SizedBox(
//                       width: 200,
//                       height: 100,
//                       child: Image.asset('assets/images/c.png'),
//                     ),
//                     const SizedBox(height: 10),
//                     SizedBox(
//                       width: 120,
//                       child: Image.asset('assets/images/Tawsella.png'),
//                     ),
//                     const SizedBox(height: 10),
//                     const CustomText(
//                       text: 'Create Account',
//                       alignment: Alignment.center,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     const SizedBox(height: 15),
//                     SizedBox(height: size.height / 100),
//                     CustomTextField(
//                       controller: nameController,
//                       hintText: 'Full Name',
//                       iconData: Icons.person,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     CustomTextField(
//                       controller: emailController,
//                       hintText: 'Email',
//                       iconData: Icons.email,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     TextField(
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         hintStyle: const TextStyle(color: Colors.black26),
//                         hintText: 'Password',
//                         prefixIcon: const Icon(
//                           Icons.lock,
//                           color: AppColors.iconColor,
//                         ),
//                         filled: true,
//                         fillColor: AppColors.textField_color,
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 20.0),
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
//                             color: AppColors.iconColor,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       obscureText: !_showPassword,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     TextField(
//                       controller: passwordConfirmationController,
//                       decoration: InputDecoration(
//                         hintStyle: const TextStyle(color: Colors.black26),
//                         hintText: 'Confirm Password',
//                         prefixIcon:
//                             const Icon(Icons.lock, color: AppColors.iconColor),
//                         filled: true,
//                         fillColor: AppColors.textField_color,
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 20.0),
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _showPassword2 = !_showPassword2;
//                             });
//                           },
//                           icon: Icon(
//                             _showPassword2
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: AppColors.iconColor,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       obscureText: !_showPassword2,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     CustomTextField(
//                       controller: phoneNumberController,
//                       hintText: '+352 681 000 000',
//                       iconData: Icons.phone_enabled_rounded,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     SizedBox(height: size.height / 70),
//                     LoadingButtonWidget(
//                       onPressed: registerUser,
//                       text: 'Sign Up',
//                     ),
//                     const SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomText(
//                           text: 'Already have an account?'.tr,
//                           fontSize: 15,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => const LoginPage());
//                           },
//                           child: const CustomText(
//                             text: 'Sign in',
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF8DD2C9),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Auth/View/loginPage.dart';
import 'package:tawsella_final/Auth/View/verification_code.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _showPassword = false;
  bool _showPassword2 = false;

  final TextEditingController NameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? genderController;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password_confirmationController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Future<void> registerUser() async {
    if (NameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        password_confirmationController.text.isEmpty ||
        phoneNumberController.text.isEmpty) {
      CustomSnackbar.show(
        context,
        'please_fill_all_fields'.tr,
      );
      return;
    }

    if (passwordController.text.length < 8) {
      CustomSnackbar.show(
        context,
        'password_min_length'.tr,
      );
      return;
    }

    if (passwordController.text != password_confirmationController.text) {
      CustomSnackbar.show(
        context,
        'passwords_do_not_match'.tr,
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text)) {
      CustomSnackbar.show(
        context,
        'invalid_email'.tr,
      );
      return;
    }

    if (!phoneNumberController.text.startsWith('+')) {
      CustomSnackbar.show(
        context,
        'phone_number_should_start_with_plus'.tr,
      );
      return;
    }

    final Map<String, dynamic> data = {
      'name': NameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': password_confirmationController.text,
      'phone_number': phoneNumberController.text,
      'gender': genderController,
    };

    final url = '${Url.url}api/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 500) {
        CustomSnackbar.show(
          context,
          'email_already_used'.tr,
        );
      }
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['data']['token'];
        final String id = responseData['data']['user']['id'];
        final String email = responseData['data']['user']['email'];
        final String name = responseData['data']['user']['profile']['name'];
        final String currentEmail = responseData['data']['user']['email'];
        final String phone = responseData['data']['user']['profile']['phone_number'];
        final String mail_code_verified_at =
            responseData['data']['user']['mail_code_verified_at'] ?? "a";

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('phone', phone);
        prefs.setString('email', currentEmail);
        prefs.setString('mail_code_verified_at', mail_code_verified_at);

        CustomSnackbar.show(
          context,
          'registration_success'.tr,
        );
        Get.off(() => const VerifyEmailPage());
      } else {
        print('Error: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
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
                    SizedBox(
                      width: 200.w,
                      height: 100.h,
                      child: Image.asset('assets/images/c.png'),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 120.w,
                      child: Image.asset('assets/images/Tawsella.png'),
                    ),
                    SizedBox(height: 10.h),
                     CustomText(
                      text: 'register_page'.tr,
                      alignment: Alignment.center,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      controller: NameController,
                      hintText: 'full_name'.tr,
                      iconData: Icons.person,
                    ),
                    SizedBox(height: size.height / 100),
                    CustomTextField(
                      controller: emailController,
                      hintText: 'email'.tr,
                      iconData: Icons.email,
                    ),
                    SizedBox(height: size.height / 100),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black26),
                        hintText: 'password'.tr,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.iconColor,
                        ),
                        filled: true,
                        fillColor: AppColors.textField_color,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
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
                            color: AppColors.iconColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: !_showPassword,
                    ),
                    SizedBox(height: size.height / 100),
                    TextField(
                      controller: password_confirmationController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.black26),
                        hintText: 'confirm_password'.tr,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.iconColor,
                        ),
                        filled: true,
                        fillColor: AppColors.textField_color,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20.0),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword2 = !_showPassword2;
                            });
                          },
                          icon: Icon(
                            _showPassword2
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.iconColor,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: !_showPassword2,
                    ),
                    SizedBox(height: size.height / 100),
                    CustomTextField(
                      controller: phoneNumberController,
                      hintText: 'phone_number'.tr,
                      iconData: Icons.phone_enabled_rounded,
                    ),
                    SizedBox(height: size.height / 100),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.textField_color,
                      ),
                      hint: Text('select_gender'.tr),
                      value: genderController,
                      items: [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('male'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('female'.tr),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          genderController = value;
                        });
                      },
                    ),
                    SizedBox(height: size.height / 100),
                    LoadingButtonWidget(
                      text: 'sign_up'.tr,
                      onPressed: registerUser,
                    ),
                    SizedBox(height: size.height / 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         CustomText(
                          text: 'already_have_account'.tr,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.off(() => const LoginPage());
                          },
                          child:  CustomText(
                            text: 'sign_in'.tr,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawsella_final/Auth/View/loginPage.dart';
// import 'package:tawsella_final/Auth/View/verification_code.dart';
// import 'package:tawsella_final/components/customTextField.dart';
// import 'package:tawsella_final/components/custom_loading_button.dart';
// import 'package:tawsella_final/components/custom_snackbar.dart';
// import 'package:tawsella_final/components/custom_text.dart';
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:tawsella_final/utils/url.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   bool _showPassword = false;
//   bool _showPassword2 = false;
//   //bool _agreeToTerms = false;

//   final TextEditingController NameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   // final TextEditingController genderController = TextEditingController();
//   String? genderController;
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController password_confirmationController =
//       TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();

//   Future<void> registerUser() async {
//     if (NameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         password_confirmationController.text.isEmpty ||
//         phoneNumberController.text.isEmpty) {
//       CustomSnackbar.show(
//         context,
//         'الرجاء ملء جميع الحقول',
//       );
//       return;
//     }

//     if (passwordController.text.length < 8) {
//       CustomSnackbar.show(
//         context,
//         'يجب أن تكون كلمة المرور على الأقل 8 أحرف',
//       );
//       return;
//     }

//     if (passwordController.text != password_confirmationController.text) {
//       CustomSnackbar.show(
//         context,
//         'كلمة المرور وتأكيد كلمة المرور غير متطابقين',
//       );
//       return;
//     }

//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//         .hasMatch(emailController.text)) {
//       CustomSnackbar.show(
//         context,
//         'الرجاء إدخال عنوان بريد إلكتروني صالح',
//       );
//       return;
//     }

//     if (!phoneNumberController.text.startsWith('+')) {
//       CustomSnackbar.show(
//         context,
//         'يجب أن يبدأ رقم الهاتف بـ "+"',
//       );
//       return;
//     }

//     final Map<String, dynamic> data = {
//       'name': NameController.text,
//       'email': emailController.text,
//       'password': passwordController.text,
//       'password_confirmation': password_confirmationController.text,
//       'phone_number': phoneNumberController.text,
//       'gender': genderController,
//     };

//     // final Uri url = Uri.parse('${Url.url}api/register');
//     final url = '${Url.url}api/register';

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: jsonEncode(data),
//       );
//       if (response.statusCode == 500) {
//         CustomSnackbar.show(
//           context,
//           'عنوان البريد الالكتروني مستخدم مسبقا يرجى تسجيل عنوان اخر ',
//         );
//       }
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final String token = responseData['data']['token'];
//         final String id = responseData['data']['user']['id'];
//         final String email = responseData['data']['user']['email'];
//         final String name = responseData['data']['user']['profile']['name'];
//         final String currentEmail = responseData['data']['user']['email'];
//         final String phone = responseData['data']['user']['profile']['phone_number'];
//         final String mail_code_verified_at =
//             responseData['data']['user']['mail_code_verified_at'] ?? "a";

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString('token', token);
//         prefs.setString('Id', id);
//         prefs.setString('name', name);
//         prefs.setString('email', email);
//         prefs.setString('phone', phone);
//         prefs.setString('email', currentEmail);
//         prefs.setString('mail_code_verified_at', mail_code_verified_at);

//         print(token);
//         print(mail_code_verified_at);

//         CustomSnackbar.show(
//           context,
//           'تم إنشاء الحساب بنجاح'.tr,
//         );
//         Get.off(() => const VerifyEmailPage());
//       } else {
//         print('Error: ${response.statusCode}');
//         print('Error: ${response.body}');
//       }
//     } catch (error) {
//       print('Error: $error');
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
//                     SizedBox(
//                       width: 200.w,
//                       height: 100.h,
//                       child: Image.asset('assets/images/c.png'),
//                     ),
//                     SizedBox(height: 10.h),
//                     SizedBox(
//                       width: 120.w,
//                       child: Image.asset('assets/images/Tawsella.png'),
//                     ),
//                     SizedBox(height: 10.h),
//                     const CustomText(
//                       text: 'Create Account',
//                       alignment: Alignment.center,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     const SizedBox(height: 15),

//                     SizedBox(height: size.height / 100),
//                     // Full Name
//                     CustomTextField(
//                       controller: NameController,
//                       hintText: 'Full Name',
//                       iconData: Icons.person,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     // Email field
//                     CustomTextField(
//                       controller: emailController,
//                       hintText: 'Email',
//                       iconData: Icons.email,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     // Password field
//                     TextField(
//                       controller: passwordController,
//                       decoration: InputDecoration(
//                         hintStyle: const TextStyle(color: Colors.black26),
//                         hintText: 'Password',
//                         prefixIcon: const Icon(
//                           Icons.lock,
//                           color: AppColors.iconColor,
//                         ),
//                         filled: true,
//                         fillColor: AppColors.textField_color,
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 20.0),
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
//                             color: AppColors.iconColor,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       obscureText: !_showPassword,
//                     ),

//                     SizedBox(height: size.height / 100),
//                     TextField(
//                       controller: password_confirmationController,
//                       decoration: InputDecoration(
//                         hintStyle: const TextStyle(color: Colors.black26),
//                         hintText: 'Conferm Password',
//                         prefixIcon: const Icon(
//                           Icons.lock,
//                           color: AppColors.iconColor,
//                         ),
//                         filled: true,
//                         fillColor: AppColors.textField_color,
//                         contentPadding:
//                             const EdgeInsets.symmetric(vertical: 20.0),
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               _showPassword2 = !_showPassword2;
//                             });
//                           },
//                           icon: Icon(
//                             _showPassword2
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: AppColors.iconColor,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide.none, // لا حدود للإطار
//                           borderRadius:
//                               BorderRadius.circular(10.0), // تدوير الحواف
//                         ),
//                       ),
//                       obscureText: !_showPassword2,
//                     ),

//                     SizedBox(height: size.height / 100),
//                     // Phone Number field
//                     CustomTextField(
//                       controller: phoneNumberController,
//                       hintText: '+352 681 000 000',
//                       iconData: Icons.phone_enabled_rounded,
//                     ),
//                     SizedBox(height: size.height / 100),
//                     // Phone Number field
//                     // CustomTextField(
//                     //   controller: genderController,
//                     //   hintText: 'gender',
//                     //   iconData: Icons.phone_enabled_rounded,
//                     // ),
//                     DropdownButtonFormField<String>(
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[200],
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 20.0),
//                         hintText: 'Select Gender',
//                         hintStyle: TextStyle(color: Colors.grey),
//                         isDense: true,
//                       ),
//                       value: genderController,
//                       items: ['male', 'female']
//                           .map((gender) => DropdownMenuItem(
//                                 value: gender,
//                                 child: Text(
//                                   gender,
//                                   style: TextStyle(color: Colors.black),
//                                 ),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           genderController = value;
//                         });
//                       },
//                       dropdownColor: Colors.white,
//                       style: TextStyle(color: Colors.blue),
//                     ),

//                     SizedBox(height: size.height / 100),
//                     SizedBox(height: size.height / 70),
//                     LoadingButtonWidget(
//                         onPressed: () {
//                           registerUser();
//                         },
//                         text: 'Sign Up'),
//                     const SizedBox(height: 15),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CustomText(
//                           text: 'Already have an account?'.tr,
//                           fontSize: 15,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => const LoginPage());
//                           },
//                           child: const CustomText(
//                             text: 'Sign in',
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF8DD2C9),
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
