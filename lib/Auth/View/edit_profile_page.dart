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
        backgroundColor: AppColors.textColor,
        title: Text(
          'edit_profile_page'.tr, // "Edit Profile Page"
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
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
                  // width: 100.w,
                  // height: 100.h,
                  child: Image.asset(
                    height: 130.h,
                    width: 150.w,
                    'assets/images/logo_star_taxi.png',
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
                hintText: 'كلمة المرور الجديدة',
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
                hintText: 'تأكيد كلمة المرور',
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
              SizedBox(height: size.height / 40),
              CustomButton(
                  border_redios: 20,
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

  // // دالة لتحديث الملف الشخصي
  // void updateProfile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token') ?? '';

  //   try {
  //     if (emailController.text.isEmpty ||
  //         nameController.text.isEmpty ||
  //         phoneController.text.isEmpty) {
  //       CustomSnackbar.show(
  //         context,
  //         'fill_all_fields'.tr,
  //       );
  //       return;
  //     }

  //     if (passwordController.text.isNotEmpty &&
  //         passwordController.text != passwordConfirmationController.text) {
  //       CustomSnackbar.show(
  //         context,
  //         'password_mismatch'.tr,
  //       );
  //       return;
  //     }

  //     Map<String, dynamic> body = {
  //       'email': emailController.text,
  //       'name': nameController.text,
  //       'phone_number': phoneController.text,
  //     };

  //     if (passwordController.text.isNotEmpty) {
  //       body['password'] = passwordController.text;
  //       body['password_confirmation'] = passwordConfirmationController.text;
  //     }

  //     final response = await http.post(
  //       Uri.parse('${Url.url}api/profile'),
  //       body: jsonEncode(body),
  //       headers: <String, String>{
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token'
  //       },
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       prefs.setString('name', nameController.text);
  //       prefs.setString('email', emailController.text);
  //       prefs.setString('phone', phoneController.text);
  //       Get.off(() => const Bottombar());
  //       log(
  //           'profile_updated_successfully'.tr);
  //     } else {
  //       log(
  //           '${'profile_update_failed'.tr}: ${response.body}');
  //     }
  //   } catch (e) {
  //     log(
  //         '${'error_updating_profile'.tr}: $e');
  //   }
  // }
}
