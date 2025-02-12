import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:tawsella_final/pages/drivers_ready/model/drivers_ready_model.dart';
import 'package:tawsella_final/utils/url.dart';

class DriverController extends GetxController {
  var isLoading = true.obs;
  var driversList = <DriversReady>[].obs;

  Future<void> fetchDrivers() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      isLoading(true);

      final response = await http.get(
        Uri.parse("${Url.url}api/drivers-ready"),
        headers: {
          "Authorization": 'Bearer $token',
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var driversModel = DriversReadyModel.fromJson(jsonData);

        if (driversModel.data != null) {
          driversList.assignAll(driversModel.data!);
        }
      } else {
        Get.snackbar("خطأ", "فشل تحميل البيانات: ${response.statusCode}");
        Get.snackbar("خطأ", "فشل تحميل البيانات: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل البيانات: $e");
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchDrivers();
    super.onInit();
  }
}
