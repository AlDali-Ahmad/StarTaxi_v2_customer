// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<String> _getToken() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token') ?? '';
// }

// class LocationService {
//   static Future<void> sendLocationToDataBase() async {
//     String apiUrl = 'http://10.0.2.2:8000/api/customer/create-taxi-movemet';
//     String token = await _getToken();
//     try {
//       // الحصول على الموقع الحالي
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // إعداد البيانات المرسلة
//       Map<String, dynamic> payload = {
//         'movement_type_id': '9288fe74-e4a3-11ee-aeed-ec2e985fe39e',
//         'start_latitude': position.latitude,
//         'start_longitude': position.longitude,
//       };

//       // إرسال الطلب POST إلى API
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: <String, String>{
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//           'Authorization': '$token'
//         },
//         body: jsonEncode(payload),
//       );

//       // التحقق مما إذا كان الطلب ناجحًا (الرمز الحالة 200)
//       if (response.statusCode == 200) {
//         print('تم إرسال بيانات الموقع بنجاح.');
//       } else {
//         print(
//             'فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء إرسال بيانات الموقع: $e');
//     }
//   }
// }
