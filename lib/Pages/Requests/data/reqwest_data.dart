import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/utils/url.dart';

Future<Map<String, dynamic>> getkmprice() async {
  print('getkmprice');
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString('token');
  String apiUrl = '${Url.url}api/getKMPrice';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );
  final Map<String, dynamic> responseData = json.decode(response.body);
  print(responseData);
  if (response.statusCode == 200) {
    print('200');
    return responseData;
  } else {
    print('${response.statusCode}');
    return responseData;
  }
}
