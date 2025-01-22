import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/auth/View/verification_code.dart';
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/Pages/welcome_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var mail_code_verified_at;
  var token;

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mail_code_verified_at = prefs.getString('mail_code_verified_at');
      token = prefs.getString('token');
      log('Token: $token');
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () async {
        // if (token != null) {
        //   Get.off(Bottombar());
        // } else {
        //   Get.off(LoginPage());
        // }
        if (mail_code_verified_at != null &&
            mail_code_verified_at != "a" &&
            token != null) {
          log('mail_code_verified_at is null: $mail_code_verified_at');
          Get.off(() => const Bottombar());
        } else if (token != null &&
            (mail_code_verified_at != null || mail_code_verified_at != "a")) {
          log('Token fff: $token');
          log('mail_code_verified_at is null: $mail_code_verified_at');
          Get.off(() => const VerifyEmailPage());
        } else {
          log('mail_code_verified_at is null: $mail_code_verified_at');
          Get.off(() => WelcomeScreens());
          // Get.off(() => Bottombar());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   width: size.width / 1.5,
            //   child: Image.asset('assets/images/c.png'),
            // ),
            // SizedBox(
            //   height: 25.h,
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SizedBox(
                child: Image.asset('assets/images/logo_star_taxi.png'),
              ),
            ),
            // const SizedBox(
            //   height: 30,
            // ),
            const SizedBox(
              width: double.infinity,
              child: SpinKitDoubleBounce(
                color: Colors.black38,
                size: 50.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
