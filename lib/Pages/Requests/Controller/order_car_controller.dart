import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/utils/url.dart';

class OrderCarService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> sendLocationToDataBase({
    required String token,
    required String? movementTypeId,
    required String startLatitude,
    required String startLongitude,
    required String myAddress,
    required String destinationAddress,
    required String gender,
  }) async {
    String apiUrl = '${Url.url}api/create-taxi-movemet';

    try {
      Map<String, dynamic> payload = {
        'movement_type_id': movementTypeId,
        'start_latitude': startLatitude,
        'start_longitude': startLongitude,
        'my_address': myAddress,
        'destnation_address': destinationAddress,
        'gender': gender,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('تم إرسال بيانات الموقع بنجاح.');
      } else {
        print(
            'فشل في إرسال بيانات الموقع. الرمز الحالة: ${response.statusCode}');
      }
    } catch (e) {
      print('حدث خطأ أثناء إرسال بيانات الموقع: $e');
    }
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
