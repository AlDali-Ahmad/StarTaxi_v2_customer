import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Auth/Controller/UserPreferences.dart';
import 'package:tawsella_final/Auth/Controller/auth_controller.dart';
import 'package:tawsella_final/Auth/View/user_info.dart';
import 'package:tawsella_final/Auth/View/verification_code.dart';
import 'package:tawsella_final/Pages/notification.dart';
import 'package:tawsella_final/components/custom_alert_dialog.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/local/lang_Page.dart';
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
      print('Error fetching phone number: $e');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.nullColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 70.h),
                InkWell(
                  onTap: () {
                    Get.to(UserInfoPage());
                  },
                  child: Card(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.network(
                            '',
                            height: 110.h,
                            width: 120.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading image: $error');
                              return Image.asset(
                                'assets/images/car1.png',
                              );
                            },
                          ),
                        ),
                        // عرض الاسم المحفوظ
                        title: Text(
                          name, // هنا نعرض الاسم
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                SizedBox(height: 50.h),
                Expanded(
                  child: ListView(
                    children: [
                      _buildProfileMenuItem(
                        icon: Icons.language,
                        title: 'Languages'.tr,
                        onTap: () {
                          Get.to(LanguagesPage());
                        },
                      ),
                      SizedBox(height: 5.h),
                      _buildProfileMenuItem(
                        icon: Icons.notifications_none_outlined,
                        title: 'Notifications'.tr,
                        onTap: () {
                          // Get.to(NotificationWidget());
                          Get.to(VerifyEmailPage());
                        },
                      ),
                      SizedBox(height: 5.h),
                      _buildProfileMenuItem(
                        icon: Icons.help_outline_sharp,
                        title: 'Support & Help'.tr,
                        onTap: () async {
                          final phoneNumber = await fetchPhoneNumber();
                          final whatsapp = Uri.parse('https://wa.me/$phoneNumber');
                          launchUrl(whatsapp);
                        },
                      ),
                      SizedBox(height: 5.h),
                      _buildProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Logout'.tr,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: 'Logout'.tr,
                                message: 'Are you sure you want to logout?'.tr,
                                cancelButtonText: 'Cancel'.tr,
                                confirmButtonText: 'Yes, Logout'.tr,
                                onCancel: () {
                                  Get.back();
                                },
                                onConfirm: () async {
                                  try {
                                    await AuthService.logout();
                                    print("Logged out successfully");
                                  } catch (error) {
                                    print("Error during logout: $error");
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
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(
                      text: 'Copyright All right reserved'.tr,
                      alignment: Alignment.center,
                      fontSize: 12,
                      color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Card(
      color: Colors.white,
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
          style: TextStyle(color: AppColors.textColor,fontSize: 14.sp),
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
