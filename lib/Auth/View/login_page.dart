import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/auth/View/regester_page.dart';
import 'package:tawsella_final/auth/controller/auth_controller_getx.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import '../../components/custom_password_field.dart';
import '../../components/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  // final AuthService _authService = AuthService();

  // Future<void> _login() async {

  //   final result = await _authService.loginUser(
  //     emailController.text,
  //     passwordController.text,
  //   );

  //   if (result != null && result.containsKey('error')) {
  //     CustomSnackbar.show(context, result['error']);
  //   } else {
  //     Get.off(() => const Bottombar());
  //   }
  // }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        controller: authController.emailController,
                        hintText: 'enter_your_email'.tr,
                        iconData: Icons.email,
                        iconColor: AppColors.iconColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email'.tr;
                          }
                          final emailRegex =
                              RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(height: 5.h),
                      CustomPasswordField(
                        controller: authController.passwordController,
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
                      SizedBox(height: 12.h),
                      LoadingButtonWidget(
                        text: 'login'.tr,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // _login();
                            authController.loginUser(
                              authController.emailController.text,
                              authController.passwordController.text,
                            );
                          }
                        },
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
                              Get.off(() => const RegisterPage());
                            },
                            child: CustomText(
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
          ),
        ],
      ),
    );
  }
}
