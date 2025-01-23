import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<Map<String, String?>> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    String? id = prefs.getString('id');
    String? token = prefs.getString('token');

    return {
      'name': name,
      'email': email,
      'token': token,
      'id': id,
    };
  }
}
