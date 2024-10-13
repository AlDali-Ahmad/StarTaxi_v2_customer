// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tawsella_final/components/customTextField.dart';
// import 'package:tawsella_final/components/custom_botton.dart';
// import 'package:tawsella_final/components/custom_snackbar.dart';
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:tawsella_final/utils/url.dart';

// import '../../Pages/bottombar.dart';

// class EditProfilePage extends StatefulWidget {
//   final String userId;
//   EditProfilePage({required this.userId});

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   bool _showPassword = false;
//   bool _showPassword2 = false;

//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController password_confirmationController =
//       TextEditingController();

//   String name = '';
//   String phoneNumber = '';
//   String email = '';

//   Future<void> userinfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('name') ?? '';
//       email = prefs.getString('email') ?? '';
//       phoneNumber = prefs.getString('phone') ?? '';

//       emailController.text = email;
//       nameController.text = name;
//       phoneController.text = phoneNumber;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     userinfo();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.BackgroundColor,
//         title: const Text(
//           'Edit Profile Page',
//           style: TextStyle(color: Colors.amber),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               SizedBox(
//                 height: 50.h,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(1.0),
//                 child: SizedBox(
//                   width: 100.w,
//                   height: 100.h,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Image.network(
//                       'assets/images/car1.png',
//                       height: 110.h,
//                       width: 120.w,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'assets/images/car1.png',
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 30.h,
//               ),
//               CustomTextField(
//                 controller: nameController,
//                 hintText: 'الاسم الجديد',
//                 iconData: Icons.person_2_outlined,
//               ),
//               SizedBox(height: size.height / 100),
//               CustomTextField(
//                 controller: phoneController,
//                 hintText: 'رقم الهاتف الجديد',
//                 iconData: Icons.phone_android,
//               ),
//               SizedBox(height: size.height / 100),
//               CustomTextField(
//                 controller: emailController,
//                 hintText: 'البريد الإلكتروني الجديد',
//                 iconData: Icons.email,
//               ),
//               SizedBox(height: size.height / 100),
//               // Password field
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   hintStyle: TextStyle(color: Colors.black26),
//                   hintText: 'تحديث كلمة المرور',
//                   prefixIcon: Icon(Icons.lock),
//                   filled: true,
//                   fillColor: Colors.blue[50],
//                   contentPadding: EdgeInsets.symmetric(vertical: 20.0),
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _showPassword = !_showPassword;
//                       });
//                     },
//                     icon: Icon(
//                       _showPassword ? Icons.visibility : Icons.visibility_off,
//                     ),
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 obscureText: !_showPassword,
//               ),
//               SizedBox(height: size.height / 100),
//               TextField(
//                 controller: password_confirmationController,
//                 decoration: InputDecoration(
//                   hintStyle: TextStyle(color: Colors.black26),
//                   hintText: 'تأكيد كلمة المرور',
//                   prefixIcon: Icon(Icons.lock),
//                   filled: true,
//                   fillColor: Colors.blue[50],
//                   contentPadding: EdgeInsets.symmetric(vertical: 20.0),
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _showPassword2 = !_showPassword2;
//                       });
//                     },
//                     icon: Icon(
//                       _showPassword2 ? Icons.visibility : Icons.visibility_off,
//                     ),
//                   ),
//                   border: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 obscureText: !_showPassword2,
//               ),
//               SizedBox(height: size.height / 80),
//               CustomButton(
//                   onPressed: () {
//                     updateProfile();
//                   },
//                   text: 'حفظ التغييرات'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // دالة لتحديث الملف الشخصي
//   void updateProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var token = prefs.getString('token') ?? '';

//     try {
//       // التحقق من ملء جميع الحقول المطلوبة باستثناء كلمة المرور
//       if (emailController.text.isEmpty ||
//           nameController.text.isEmpty ||
//           phoneController.text.isEmpty) {
//         CustomSnackbar.show(
//           context,
//           'الرجاء ملئ كامل الحقول',
//         );
//         return;
//       }

//       // التحقق من تطابق كلمتي المرور (إذا كان هناك إدخال لكلمة المرور)
//       if (passwordController.text.isNotEmpty &&
//           passwordController.text != password_confirmationController.text) {
//         CustomSnackbar.show(
//           context,
//           'كلمة المرور غير متطابقة',
//         );
//         return;
//       }

//       // إعداد البيانات التي سيتم إرسالها إلى السيرفر
//       Map<String, dynamic> body = {
//         'email': emailController.text,
//         'name': nameController.text,
//         'phone_number': phoneController.text,
//       };

//       // إضافة كلمة المرور فقط إذا كانت غير فارغة
//       if (passwordController.text.isNotEmpty) {
//         body['password'] = passwordController.text;
//         body['password_confirmation'] = password_confirmationController.text;
//       }

//       final response = await http.post(
//         Uri.parse('${Url.url}api/profile'),
//         body: jsonEncode(body),
//         headers: <String, String>{
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token'
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // تحديث SharedPreferences بالبيانات الجديدة
//         prefs.setString('name', nameController.text);
//         prefs.setString('email', emailController.text);
//         prefs.setString('phone', phoneController.text);
//         Get.off(() => const Bottombar());
//         print('تم تحديث الملف الشخصي بنجاح');
//       } else {
//         print('فشل في تحديث الملف الشخصي: ${response.body}');
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء تحديث الملف الشخصي: $e');
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_botton.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';
import '../../Pages/bottombar.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _showPassword = false;
  bool _showPassword2 = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password_confirmationController =
      TextEditingController();

  String name = '';
  String phoneNumber = '';
  String email = '';

  Future<void> userinfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phone') ?? '';

      emailController.text = email;
      nameController.text = name;
      phoneController.text = phoneNumber;
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
          icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
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
                controller: nameController,
                hintText: 'new_name'.tr, // "الاسم الجديد"
                iconData: Icons.person_2_outlined,
              ),
              SizedBox(height: size.height / 100),
              CustomTextField(
                controller: phoneController,
                hintText: 'new_phone_number'.tr, // "رقم الهاتف الجديد"
                iconData: Icons.phone_android,
              ),
              SizedBox(height: size.height / 100),
              CustomTextField(
                controller: emailController,
                hintText: 'new_email'.tr, // "البريد الإلكتروني الجديد"
                iconData: Icons.email,
              ),
              SizedBox(height: size.height / 100),
              // Password field
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.black26),
                  hintText: 'update_password'.tr, // "تحديث كلمة المرور"
                  prefixIcon: Icon(Icons.lock,color:AppColors.iconColor),
                  filled: true,
                  fillColor: AppColors.textField_color,
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,color:AppColors.iconColor
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
                  hintStyle: TextStyle(color: Colors.black26),
                  hintText: 'confirm_password'.tr,
                  prefixIcon: Icon(Icons.lock,color:AppColors.iconColor),
                  filled: true,
                  fillColor: AppColors.textField_color,
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword2 = !_showPassword2;
                      });
                    },
                    icon: Icon(
                      _showPassword2 ? Icons.visibility : Icons.visibility_off,color:AppColors.iconColor
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: !_showPassword2,
              ),
              SizedBox(height: size.height / 80),
              CustomButton(
                  onPressed: () {
                    updateProfile();
                  },
                  text: 'save_changes'.tr // "حفظ التغييرات"
                  ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة لتحديث الملف الشخصي
  void updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    try {
      // التحقق من ملء جميع الحقول المطلوبة باستثناء كلمة المرور
      if (emailController.text.isEmpty ||
          nameController.text.isEmpty ||
          phoneController.text.isEmpty) {
        CustomSnackbar.show(
          context,
          'fill_all_fields'.tr, // "الرجاء ملئ كامل الحقول"
        );
        return;
      }

      // التحقق من تطابق كلمتي المرور (إذا كان هناك إدخال لكلمة المرور)
      if (passwordController.text.isNotEmpty &&
          passwordController.text != password_confirmationController.text) {
        CustomSnackbar.show(
          context,
          'password_mismatch'.tr, // "كلمة المرور غير متطابقة"
        );
        return;
      }

      // إعداد البيانات التي سيتم إرسالها إلى السيرفر
      Map<String, dynamic> body = {
        'email': emailController.text,
        'name': nameController.text,
        'phone_number': phoneController.text,
      };

      // إضافة كلمة المرور فقط إذا كانت غير فارغة
      if (passwordController.text.isNotEmpty) {
        body['password'] = passwordController.text;
        body['password_confirmation'] = password_confirmationController.text;
      }

      final response = await http.post(
        Uri.parse('${Url.url}api/profile'),
        body: jsonEncode(body),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // تحديث SharedPreferences بالبيانات الجديدة
        prefs.setString('name', nameController.text);
        prefs.setString('email', emailController.text);
        prefs.setString('phone', phoneController.text);
        Get.off(() => const Bottombar());
        print('profile_updated_successfully'.tr); // "تم تحديث الملف الشخصي بنجاح"
      } else {
        print('${'profile_update_failed'.tr}: ${response.body}'); // "فشل في تحديث الملف الشخصي"
      }
    } catch (e) {
      print('${'error_updating_profile'.tr}: $e'); // "حدث خطأ أثناء تحديث الملف الشخصي"
    }
  }
}

