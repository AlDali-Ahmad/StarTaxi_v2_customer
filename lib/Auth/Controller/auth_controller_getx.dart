import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/auth/view/verification_code.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/utils/url.dart';


class AuthController extends GetxController {
  // تعريف المتغيرات
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmationController = TextEditingController();
  var phoneNumberController = TextEditingController();
  String genderController = ""; 

  // دالة التسجيل
  Future<void> registerUser() async {
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': passwordConfirmationController.text,
      'phone_number': phoneNumberController.text,
      'gender': genderController,
    };

    final url = '${Url.url}api/register'; // تأكد من أن لديك `Url.url`

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
          Get.context!,
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
        final String phone =
            responseData['data']['user']['profile']['phone_number'];
        final String mail_code_verified_at =
            responseData['data']['user']['mail_code_verified_at'] ?? "a";

        // تخزين البيانات في SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('phone', phone);
        prefs.setString('email', currentEmail);
        prefs.setString('mail_code_verified_at', mail_code_verified_at);

        // التوجيه إلى صفحة التحقق من البريد الإلكتروني
        Get.off(() => const VerifyEmailPage());
      } else {
        log('Error: ${response.statusCode}');
        log('Error: ${response.body}');
      }
    } catch (error) {
      log('Error: $error');
    }
  }

  // دالة تسجيل الدخول
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('${Url.url}api/login'), // تأكد من تحديد الرابط الصحيح
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['data']['token'];
        final String id = responseData['data']['user']['id'];
        final String email = responseData['data']['user']['email'];
        final String name = responseData['data']['user']['profile']['name'];
        final String phone = responseData['data']['user']['profile']['phone_number'];
        final String currentEmail = responseData['data']['user']['email'];
        final String mail_code_verified_at =
            responseData['data']['user']['mail_code_verified_at'];

        // تخزين البيانات في SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('phone', phone);
        prefs.setString('email', email);
        prefs.setString('email', currentEmail);
        prefs.setString('mail_code_verified_at', mail_code_verified_at);
        log('token: $token');
        return responseData;
      } else if (response.statusCode == 422) {
        return {
          'error': 'Invalid email or password',
        };
      } else {
        return {
          'error': 'Server error: ${response.statusCode}',
        };
      }
    } catch (error) {
      return {
        'error': 'Error occurred: $error',
      };
    }
  }

    // دالة لتحديث الملف الشخصي
  void updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token') ?? '';

    try {
      // if (emailController.text.isEmpty ||
      //     nameController.text.isEmpty ||
      //     phoneNumberController.text.isEmpty) {
      //   CustomSnackbar.show(
      //     ',
      //     'fill_all_fields'.tr,
      //   );
      //   return;
      // }

      if (passwordController.text.isNotEmpty &&
          passwordController.text != passwordConfirmationController.text) {
        // CustomSnackbar.show(
        //   context,
        //   'password_mismatch'.tr,
        // );
        return;
      }

      Map<String, dynamic> body = {
        'email': emailController.text,
        'name': nameController.text,
        'phone_number': phoneNumberController.text,
      };

      if (passwordController.text.isNotEmpty) {
        body['password'] = passwordController.text;
        body['password_confirmation'] = passwordConfirmationController.text;
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
        prefs.setString('name', nameController.text);
        prefs.setString('email', emailController.text);
        prefs.setString('phone', phoneNumberController.text);
        Get.off(() => const Bottombar());
        log(
            'profile_updated_successfully'.tr);
      } else {
        log(
            '${'profile_update_failed'.tr}: ${response.body}');
      }
    } catch (e) {
      log(
          '${'error_updating_profile'.tr}: $e'); 
    }
  }
}
