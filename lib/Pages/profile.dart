import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/auth/controller/UserPreferences.dart';
import 'package:tawsella_final/auth/controller/auth_controller.dart';
import 'package:tawsella_final/auth/View/user_info.dart';
import 'package:tawsella_final/components/custom_alert_dialog.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/pages/drivers_ready/page/drivers_ready_page.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String phoneNumber;
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchPhoneNumber().then((value) {
      setState(() {
        phoneNumber = value ?? '';
      });
    });

    // جلب بيانات المستخدم المحفوظة
    fetchUserInfo();
  }

  Future<String?> fetchPhoneNumber() async {
    try {
      final response = await http.get(Uri.parse('${Url.url}api/phone'));
      if (response.statusCode == 200) {
        String responseData = response.body;
        return responseData;
      } else {
        throw Exception('Failed to load phone number');
      }
    } catch (e) {
      log('Error fetching phone number: $e');
      return null;
    }
  }

  // جلب البيانات المحفوظة
  void fetchUserInfo() async {
    Map<String, String?> userInfo = await UserPreferences.getUserInfo();

    setState(() {
      name = userInfo['name'] ?? 'Unknown';
      email = userInfo['email'] ?? 'Unknown';
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.nullColor,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo_star_taxi.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  InkWell(
                    onTap: () {
                      Get.to(UserInfoPage());
                    },
                    child: Card(
                      color: AppColors.white.withOpacity(0.8), // شفافية بسيطة
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/images/logo_star_taxi.png',
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(email),
                          trailing: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.iconColor),
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              size: 17,
                              color: AppColors.iconColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Expanded(
                    child: ListView(
                      children: [
                        // SizedBox(height: 100.h),
                        // _buildProfileMenuItem(
                        //   icon: Icons.language,
                        //   title: 'Languages'.tr,
                        //   onTap: () {
                        //     Get.to(const LanguagesPage());
                        //   },
                        // ),
                        _buildProfileMenuItem(
                          icon: Icons.help_outline_sharp,
                          title: "السائقين المتاحين",
                          onTap: () async {
                            Get.to(DriversReadyPage());
                          },
                        ),
                        _buildProfileMenuItem(
                          icon: Icons.help_outline_sharp,
                          title: 'Support & Help'.tr,
                          onTap: () async {
                            final phoneNumber = await fetchPhoneNumber();
                            final whatsapp =
                                Uri.parse('https://wa.me/$phoneNumber');
                            launchUrl(whatsapp);
                          },
                        ),
                        SizedBox(height: 5.h),
                        _buildProfileMenuItem(
                          colors: Colors.red.shade200,
                          icon: Icons.logout,
                          title: 'Logout'.tr,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertDialog(
                                  title: 'Logout'.tr,
                                  message:
                                      'Are you sure you want to logout?'.tr,
                                  cancelButtonText: 'Cancel'.tr,
                                  confirmButtonText: 'Yes, Logout'.tr,
                                  onCancel: () {
                                    Get.back();
                                  },
                                  onConfirm: () async {
                                    try {
                                      await AuthService.logout();
                                      log("Logged out successfully");
                                    } catch (error) {
                                      log("Error during logout: $error");
                                    }
                                  },
                                  icon: Icons.logout,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      text: 'Copyright All right reserved'.tr,
                      alignment: Alignment.center,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color colors = AppColors.white,
    Widget? trailing,
  }) {
    return Card(
      color: colors,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            height: 40,
            width: 40,
            child: Icon(icon, color: const Color.fromARGB(255, 48, 48, 48)),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.iconColor),
          ),
          child: trailing ??
              const Icon(Icons.chevron_right,
                  size: 17, color: AppColors.iconColor),
        ),
        onTap: onTap,
      ),
    );
  }
}
