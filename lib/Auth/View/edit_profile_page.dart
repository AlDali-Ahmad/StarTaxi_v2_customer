import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/auth/controller/auth_controller_getx.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_botton.dart';
import 'package:tawsella_final/components/custom_password_field.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // final nameController = TextEditingController();
  // final phoneController = TextEditingController();
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  // final passwordConfirmationController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  String name = '';
  String phoneNumber = '';
  String email = '';

  Future<void> userinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phone') ?? '';

      authController.emailController.text = email;
      authController.nameController.text = name;
      authController.phoneNumberController.text = phoneNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    userinfo();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        title: Text(
          'edit_profile_page'.tr, // "Edit Profile Page"
          style: const TextStyle(color: Colors.amber),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.blue1),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      'assets/images/car1.png',
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
              SizedBox(
                height: 30.h,
              ),
              CustomTextField(
                controller: authController.nameController,
                hintText: 'new_name'.tr, // "الاسم الجديد"
                iconData: Icons.person_2_outlined,
              ),
              SizedBox(height: size.height / 100),
              CustomTextField(
                controller: authController.phoneNumberController,
                hintText: 'new_phone_number'.tr,
                iconData: Icons.phone_android,
              ),
              SizedBox(height: size.height / 100),
              CustomTextField(
                controller: authController.emailController,
                hintText: 'new_email'.tr,
                iconData: Icons.email,
              ),
              SizedBox(height: size.height / 100),
              // Password field
              CustomPasswordField(
                controller: authController.passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password'.tr;
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height / 100),
              CustomPasswordField(
                hintText: 'confirm_password'.tr,
                controller: authController.passwordConfirmationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password'.tr;
                  }
                  if (value != authController.passwordController.text) {
                    return 'Passwords do not match'.tr;
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height / 80),
              CustomButton(
                  onPressed: () {
                    authController.updateProfile();
                  },
                  text: 'save_changes'.tr),
            ],
          ),
        ),
      ),
    );
  }
}
