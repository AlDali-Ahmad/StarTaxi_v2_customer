import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  var notifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs; 

  @override
  void initState() {
    super.initState();
    fetchLatestMovement();
  }

  Future<void> fetchLatestMovement() async {
    final url = '${Url.url}api/movements/latest';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          notifications.add({
            'driverName': data['driver']['name'],
            'driverPhone': data['driver']['phone_number'],
            'timestamp': DateTime.now().toString(),
          });
        }
      } else {
        print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false; // انتهاء عملية التحميل
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.BackgroundColor,
        title: Text(
          'Order Details'.tr,
          style: const TextStyle(color: Colors.amber),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange1),
            ),
          );
        }

        if (notifications.isEmpty) {
          return Center(
            child: Text(
              'You have not sent requests yet'.tr,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            var notification = notifications[index];
            String formattedDateTime = DateFormat('yyyy-MM-dd – kk:mm:ss')
                .format(DateTime.parse(notification['timestamp']!));

            return Card(
              margin: const EdgeInsets.all(10),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New request accepted'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.orange1,
                      ),
                    ),
                    Text(
                      'تاريخ الطلب: $formattedDateTime',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text('${'driverName'.tr}: ${notification['driverName']}'),
                    Text('${'driverPhone'.tr}: ${notification['driverPhone']}'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      child: Text('Order Cancel'.tr,style:TextStyle(color: AppColors.orange2),),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
