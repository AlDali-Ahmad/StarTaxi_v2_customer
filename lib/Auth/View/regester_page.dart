import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/auth/View/login_page.dart';
import 'package:tawsella_final/auth/View/verification_code.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';

import '../../components/custom_password_field.dart';
import '../../components/custom_phone_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? genderController;
  // final AuthController authController = Get.put(AuthController());
  Future<void> registerUser() async {
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': passwordConfirmationController.text,
      'phone_number': phoneNumberController.text,
      'gender': genderController,
      'address': addressController.text,
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
        final String address = responseData['data']['user']['address'];
        final String phone =
            responseData['data']['user']['profile']['phone_number'];
        final String mail_code_verified_at =
            responseData['data']['user']['mail_code_verified_at'] ?? "a";

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('phone', phone);
        prefs.setString('address', address);
        prefs.setString('email', currentEmail);
        prefs.setString('mail_code_verified_at', mail_code_verified_at);
        Get.off(() => const VerifyEmailPage());
      } else {
        log('Error: ${response.statusCode}');
        log('Error: ${response.body}');
      }
    } catch (error) {
      log('Error: $error');
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Image.asset("assets/images/logo_star_taxi.png",),
                      ),
                      CustomText(
                        text: 'register_page'.tr,
                        alignment: Alignment.center,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        controller: nameController,
                        hintText: 'full_name'.tr,
                        iconData: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height / 100),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'email'.tr,
                        iconData: Icons.email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'.tr;
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'Please enter a valid email'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height / 100),
                      CustomTextField(
                        controller: addressController,
                        hintText: 'مكان اقامتك',
                        iconData: Icons.location_city,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال مكان اقامتك';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height / 100),
                      CustomPasswordField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password'.tr;
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long'
                                .tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height / 100),
                      CustomPasswordField(
                        hintText: 'confirm_password'.tr,
                        controller: passwordConfirmationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password'.tr;
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match'.tr;
                          }
                          return null;
                        },
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
                            genderController = value ?? '';
                          });
                        },
                      ),
                      SizedBox(height: size.height / 100),
                      CustomPhoneField(
                        controller: phoneNumberController,
                        onChanged: (phone) {},
                        onCountryChanged: (country) {},
                      ),
                      LoadingButtonWidget(
                        text: 'sign_up'.tr,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            registerUser();
                            // authController.registerUser();
                          }
                        },
                      ),
                      SizedBox(height: size.height / 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: 'already_have_account'.tr,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: AppColors.textColor,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.off(() => const LoginPage());
                            },
                            child: CustomText(
                              text: 'sign_in'.tr,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8DD2C9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
