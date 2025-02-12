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
  var addressController = TextEditingController();
  String genderController = "";

  // دالة التسجيل
  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? devicetoken = prefs.getString('device_token');
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'password_confirmation': passwordConfirmationController.text,
      'phone_number': phoneNumberController.text,
      'gender': genderController,
      'device_token': devicetoken ?? '',
    };
    print(data);

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

  void showErrorSnackbar(String message) {
    Get.snackbar(
      'تنبيه',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }

  // دالة تسجيل الدخول
  Future<void> loginUser(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? devicetoken = prefs.getString('device_token');
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'device_token': devicetoken ?? '',
    };

    try {
      final response = await http.post(
        Uri.parse('${Url.url}api/login'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      log('Response Status: ${response.statusCode}');
      log('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['data']['token'];
        final String id = responseData['data']['user']['id'];
        final String email = responseData['data']['user']['email'];
        final String name = responseData['data']['user']['profile']['name'];
        final String address =
            responseData['data']['user']['profile']['address'];
        final String phone =
            responseData['data']['user']['profile']['phone_number'];
        final String mailCodeVerifiedAt =
            responseData['data']['user']['mail_code_verified_at'];
        final bool isActive = responseData['data']['user']['is_active'] ?? true;
        final bool isBanned =
            responseData['data']['user']['is_banned'] ?? false;

        if (!isActive) {
          showErrorSnackbar(
              'الحساب غير مفعل، يرجى التحقق من بريدك الإلكتروني لتفعيله.');
          return;
        }

        if (isBanned) {
          showErrorSnackbar('تم حظر حسابك، يرجى التواصل مع الدعم الفني.');
          return;
        }

        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('phone', phone);
        prefs.setString('address', address);
        prefs.setString('email', email);
        prefs.setString('mail_code_verified_at', mailCodeVerifiedAt);

        log('token: $token');
        Get.off(() => const Bottombar());
      } else if (response.statusCode == 422) {
        showErrorSnackbar(
            'يرجى التحقق من صحة البريد الإلكتروني أو كلمة المرور.');
      } else if (response.statusCode == 500 || response.statusCode == 503) {
        showErrorSnackbar('خطأ في الخادم، يرجى المحاولة لاحقًا.');
      } else {
        showErrorSnackbar('حدث خطأ غير متوقع: ${response.statusCode}');
      }
    } catch (error) {
      if (error.toString().contains('SocketException')) {
        showErrorSnackbar(
            'تعذر الاتصال بالخادم، يرجى التحقق من اتصال الإنترنت والمحاولة مرة أخرى.');
      } else if (error.toString().contains('TimeoutException')) {
        showErrorSnackbar('انتهت مهلة الاتصال بالخادم، يرجى المحاولة مجددًا.');
      } else {
        showErrorSnackbar('حدث خطأ: $error');
      }
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
        'address': addressController.text,
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
        prefs.setString('address', phoneNumberController.text);
        Get.off(() => const Bottombar());
        log('profile_updated_successfully'.tr);
      } else {
        log('${'profile_update_failed'.tr}: ${response.body}');
      }
    } catch (e) {
      log('${'error_updating_profile'.tr}: $e');
    }
  }
}
