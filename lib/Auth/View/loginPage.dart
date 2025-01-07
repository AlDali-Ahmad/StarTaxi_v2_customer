import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
import 'package:tawsella_final/Auth/View/regesterPage.dart';
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
      Get.off(()=>const Bottombar());
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
                        hintStyle: const TextStyle(color: AppColors.iconColor),
                        prefixIcon:
                            const Icon(Icons.lock, color: AppColors.iconColor),
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
                            color: const Color(0xFF8DD2C9),
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