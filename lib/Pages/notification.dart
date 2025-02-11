import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Pages/chat_screen.dart';
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

  Future<void> cancelMovement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? movement_id = prefs.getString('movement_id');
    final url = '${Url.url}api/movements/cancel/$movement_id';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          '',
          'The order was canceled successfully'.tr,
          colorText: AppColors.white,
        );
        log('Request cancelled successfully');
        // fetchLatestMovement();
        setState(() {});
        Get.off(MyOrdersPage());
      } else {
        log('${movement_id}');
        log('Failed to cancel request, status code: ${response.statusCode}');
        log('Failed to: ${response.body}');
      }
    } catch (e) {
      log('Error: $e');
    }
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
        log(data);
        log(data['driver']['user_id']);
        String chat_id = data['chat_id'];
        String driver_id = data['driver']['user_id'];
        await prefs.setString('chat_id', chat_id);
        await prefs.setString('driver_id', driver_id);
        log(data['chat_id']);
        if (data != null) {
          notifications.add({
            'driverName': data['driver']['name'],
            'driverPhone': data['driver']['phone_number'],
            'timestamp': DateTime.now().toString(),
          });
        }
      } else {
        log(response.body);
        log('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.textColor,
        title: const Text(
          'تفاصيل الطلب',
          style: TextStyle(color: AppColors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            cancelMovement();
                          },
                          child: Text(
                            'Order Cancel'.tr,
                            style: const TextStyle(color: AppColors.orange2),
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => ChatScreen());
                          },
                          child: Text(
                            'Go To Chat'.tr,
                            style: const TextStyle(color: AppColors.orange2),
                          ),
                        ),
                      ],
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
