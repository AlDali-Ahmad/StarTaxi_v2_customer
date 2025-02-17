import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Pages/Requests/data/reqwest_data.dart';
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';
import 'package:http/http.dart' as http;

class OrderDetailsPage extends StatefulWidget {
  final String from;
  final String to;
  final String tybe;
  final String gender;
  final double price;
  final Position startPosition;
  final Position endPosition;
  final String movementtypeid;

  const OrderDetailsPage({
    super.key,
    required this.from,
    required this.to,
    required this.tybe,
    required this.gender,
    required this.price,
    required this.startPosition,
    required this.endPosition,
    required this.movementtypeid,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String, dynamic> responseData = {};
  double price1 = 0;
  String payment1 = '';
  double price2 = 0;
  String payment2 = '';
  double kmdis = 0;
  String? _token;
  bool isloading = true;
  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  Future<void> sendLocationToDataBase() async {
    String apiUrl = '${Url.url}api/movements';
    try {
      // // الحصول على الموقع الحالي
      // Position position = await Geolocator.getCurrentPosition(
      //   desiredAccuracy: LocationAccuracy.high,
      // );

      // التحقق من أن الحقول غير فارغة

      // إعداد البيانات لإرسالها إلى الـ API
      Map<String, dynamic> payload = {
        'movement_type_id': widget.movementtypeid,
        'start_latitude': widget.startPosition.latitude,
        'start_longitude': widget.startPosition.longitude,
        'start_address': widget.from,
        'destination_address': widget.to,
        'gender': widget.gender,
      };

      // إرسال الطلب
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
        body: jsonEncode(payload),
      );

      // التحقق من نجاح الطلب
      if (response.statusCode == 200) {
        // تحليل الاستجابة لاستخراج الـ movement_id
        var responseBody = jsonDecode(response.body);
        String movementId = responseBody['data']['movement_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('movement_id', movementId);

        log('تم إرسال بيانات الموقع بنجاح.');
        log('Movement ID: $movementId');

        // عرض رسالة نجاح باستخدام Get.snackbar
        Get.snackbar(
          '',
          'Your request has been created successfully'.tr,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
        );

        // الانتقال إلى الصفحة التالية بعد النجاح
        Get.off(() => const Bottombar());
      } else if (response.statusCode == 429) {
        Get.snackbar(
          '',
          'You have recently requested a car. Please wait a moment while your request is being processed'
              .tr,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
        );
      } else {
        log('فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
        log('فشل في إرسال بيانات الموقع. الاستجابة: ${response.body}');
      }
    } catch (e) {
      log('حدث خطأ أثناء إرسال بيانات الموقع: $e');
    }
  }

  Future<double> calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    return distanceInMeters / 1000; // Convert meters to km
  }

  inject() async {
    responseData = await getkmprice();
    price1 = responseData['data']?['price1'] ?? 0;
    payment1 = responseData['data']?['payment1'] ?? "";
    price2 = responseData['data']?['price2'] ?? 0;
    payment2 = responseData['data']?['payment2'] ?? "";
    kmdis = await calculateDistance(
      widget.startPosition.latitude,
      widget.startPosition.longitude,
      widget.endPosition.latitude,
      widget.endPosition.longitude,
    );
    print(kmdis);
    price1 = price1 * kmdis;

    price2 = price2 * kmdis;
    isloading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inject();
      _getToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "تفاصيل الطلب",
          style: TextStyle(color: AppColors.textColor, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: (isloading)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.orange1,
                  strokeWidth: 5.w,
                ),
                Text(
                  'جار حساب المسافة والسعر التقريبي',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(height: 10),
                _buildInfoCard("التوجه من", widget.from, Icons.location_on),
                _buildInfoCard("التوجه إلى", widget.to, Icons.location_on),
                _buildInfoCard("نوع الطلب", widget.tybe, Icons.pedal_bike),
                _buildInfoCard("جنس السائق", widget.gender, Icons.person),
                // _buildInfoCard("الوقت لوصول السائق", "07:00 دقيقة", Icons.access_time,
                //     isBlue: true),
                _buildInfoCard("المسافة المحسوبة",
                    "${kmdis.toStringAsFixed(2)} KM", Icons.calculate_rounded,
                    isBlue: false),
                _buildInfoCard(
                    "السعر المتوقع للرحلة",
                    '${price1.toStringAsFixed(2)}$payment1 / ${price2.toStringAsFixed(2)}$payment2',
                    Icons.attach_money,
                    isBlue: true),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      // Confirm order action
                      if (_token != null && _token!.isNotEmpty) {
                        sendLocationToDataBase();
                      } else {
                        CustomSnackbar.show(
                          context,
                          'تأكد من تسجيل الدخول أولاً',
                        );
                      }
                    },
                    child: const Text(
                      "تأكيد الطلب",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon,
      {bool isBlue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: TextStyle(
              color: isBlue ? Colors.blue : Colors.black,
              fontWeight: isBlue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
