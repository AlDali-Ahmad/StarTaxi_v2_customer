import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // استخدم لتحويل القوائم إلى JSON

class NotificationController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications(); // تحميل الإشعارات عند بدء التشغيل
  }

  void addNotification(String driverName, String driverPhone,/* int driverGender*/) {
    var notification = {
      'driverName': driverName,
      'driverPhone': driverPhone,
      // 'driverGender': driverGender,
      'timestamp': DateTime.now().toIso8601String(), // حفظ الوقت الحالي بتنسيق ISO
    };

    notifications.add(notification);
    saveNotifications(); // حفظ الإشعارات بعد الإضافة
  }

  void deleteNotification(int index) {
    if (index >= 0 && index < notifications.length) {
      notifications.removeAt(index);
      saveNotifications(); // حفظ الإشعارات بعد الحذف
    }
  }

  Future<void> saveNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> notificationsJson = notifications.map((notification) => jsonEncode(notification)).toList();
      
      print('Saving notifications: $notificationsJson'); // سجل الإشعارات التي تم حفظها
      
      await prefs.setStringList('notifications', notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e'); // سجل الأخطاء
    }
  }

  Future<void> loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? notificationsJson = prefs.getStringList('notifications');

    print('Loaded notifications: $notificationsJson'); // سجل الإشعارات التي تم تحميلها

    if (notificationsJson != null) {
      notifications.value = notificationsJson
          .map((notification) => jsonDecode(notification))
          .cast<Map<String, String>>()
          .toList();
    }
  }
}
