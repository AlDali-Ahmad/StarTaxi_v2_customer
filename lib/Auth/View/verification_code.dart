import 'dart:convert';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/auth/View/regester_page.dart';
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/utils/url.dart';
import '../../components/Custom_text.dart';
import '../../utils/app_colors.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  String _pinCode = '';
  String? _token;
  late String? email;

  String mail_code_verified_at = "ass";

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  Future<void> _getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  Future<void> verifyEmail() async {
    if (_token == null) {
      log("Token is null, please check if it's retrieved correctly.");
      return;
    }
    String apiUrl = '${Url.url}api/verify-mail';

    // Ensure the pin code consists of 6 digits
    if (_pinCode.length != 6) {
      log("The confirmation code must consist of 6 digits.");
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'code': _pinCode,
      }),
    );

    if (response.statusCode == 200) {
      log("Verification successful!");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('mail_code_verified_at', mail_code_verified_at);
      Get.off(const Bottombar());
    } else {
      log('$_token');
      log("Error ${response.statusCode}: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _getEmail();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 70.h),
                  SizedBox(
                    height: 70.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.asset(
                        "assets/images/car1.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                   CustomText(
                    text: 'verificationCode'.tr,
                    fontWeight: FontWeight.bold,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 15.h),
                   CustomText(
                    text: 'pleaseEnterCode'.tr,
                    fontSize: 15,
                    alignment: Alignment.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       CustomText(
                        text: 'email'.tr,
                        fontSize: 15,
                      ),
                      CustomText(
                        text: email!,
                        fontSize: 15,
                        color: AppColors.orange1,
                      ),
                    ],
                  ),
                  SizedBox(height: (size.height / 10) / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => _buildPinInputField(index),
                    ),
                  ),
                  SizedBox(height: (size.height / 10) / 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'tryAnotherEmail'.tr,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      InkWell(
                        onTap: () {
                          Get.off(const RegisterPage());
                        },
                        child: Text(
                          'signUp'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.orange1,
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (size.height / 10) / 4),
                  LoadingButtonWidget(
                    text: 'enter'.tr,
                    onPressed: () {
                      verifyEmail();
                    },
                    backgroundColor1: AppColors.orange1,
                    backgroundColor2: AppColors.orange2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinInputField(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.textField_color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            maxLength: 1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: index == -1 ? "" : "-",
              hintStyle: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              counterText: "",
            ),
            style: const TextStyle(fontSize: 24),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _pinCode += value;
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                }
                if (_pinCode.length == 6) {
                  // handle 6-digit code here
                  verifyEmail(); // Trigger verification when the code is complete
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
