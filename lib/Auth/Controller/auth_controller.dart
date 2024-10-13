import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Auth/View/loginPage.dart';
import 'package:tawsella_final/Pages/splash_screen.dart';
import 'package:tawsella_final/utils/url.dart';

class AuthService {
  final Uri loginUrl = Uri.parse('${Url.url}api/login');
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        loginUrl,
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

        // Save token and user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('phone', phone);
        prefs.setString('email', email);
        prefs.setString('email', currentEmail);
        prefs.setString('mail_code_verified_at', mail_code_verified_at);
        print('token zsssss:${token}');
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

  final String _baseUrl = '${Url.url}api';

  Future<Map<String, dynamic>?> registerUser(
      {required String name,
      required String email,
      required String password,
      required String passwordConfirmation,
      required String phoneNumber}) async {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone_number': phoneNumber,
    };

    final Uri url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['data']['token'];
        final String email = responseData['data']['user']['email'];
        final String id = responseData['data']['user']['id'];
        final String name = responseData['data']['user']['profile']['name'];
        final String mail_code_verified_at = responseData['data']['mail_code_verified_at'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', email);
        await prefs.setString('id', id);
        await prefs.setString('name', name);
        await prefs.setString('mail_code_verified_at', mail_code_verified_at);

        return responseData;
      } else if (response.statusCode == 500) {
        return {'error': 'Email already in use'};
      } else {
        return {'error': 'Unexpected error: ${response.statusCode}'};
        // print('Unexpected error: ${response.statusCode}');
      }
    } catch (error) {
      return {'error': 'Failed to register: $error'};
    }
  }

  static Future<String> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final Uri url = Uri.parse('${Url.url}api/profile');
    String token = await _getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load user data: $error');
    }
  }

  static Future<void> logout() async {
    final String apiUrl = '${Url.url}api/logout';
    String token = await _getToken();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        Get.off(() => const SplashScreen());
      } else {
        print(token);
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to log out: ${response.statusCode}');
        // Get.off(() => const LoginPage());
      }
    } catch (error) {
      throw Exception('Failed to log out: $error');
    }
  }
}
