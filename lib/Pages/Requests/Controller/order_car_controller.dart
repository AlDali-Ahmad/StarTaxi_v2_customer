import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // لإدارة المتغيرات البيئية
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/utils/url.dart';

class OrderCarController extends GetxController {
  GoogleMapController? mapController;
  final RxList<Marker> markers = <Marker>[].obs; // ماركرز الخريطة
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  final RxDouble distance = 0.0.obs; // المسافة المقدرة

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(36.586038, 37.044871), // الموقع الافتراضي
    zoom: 10.4746,
  );

  final TextEditingController destinationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final RxString gender = RxString('male'); // قيمة افتراضية
  final RxString selectedRequestType = RxString('t-m-t-1'); // قيمة افتراضية
  final RxString token = RxString(''); // قيمة افتراضية

  // استرداد مفتاح Google Maps API من ملف .env
  final String googleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  @override
  void onInit() {
    super.onInit();
    _initializeLocation(); // تهيئة الموقع
    _getToken(); // الحصول على التوكن
  }

  // تهيئة الموقع الحالي
  Future<void> _initializeLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      _updateMarkers(position); // تحديث الماركرز
      _moveCameraToPosition(position); // تحريك الكاميرا إلى الموقع الحالي
    }
  }

  // تحديث الماركرز
  void _updateMarkers(Position position) {
    markers.add(Marker(
      markerId: const MarkerId("current_location"),
      position: LatLng(position.latitude, position.longitude),
    ));
  }

  // تحريك الكاميرا إلى الموقع الحالي
  void _moveCameraToPosition(Position position) {
    mapController?.animateCamera(CameraUpdate.newLatLng(
      LatLng(position.latitude, position.longitude),
    ));
  }

  // الحصول على التوكن من SharedPreferences
  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value =
        prefs.getString('token') ?? ''; // استخدام قيمة افتراضية إذا كانت null
  }

  // إرسال بيانات الموقع إلى قاعدة البيانات
  Future<void> sendLocationToDatabase() async {
    if (locationController.text.isEmpty ||
        destinationController.text.isEmpty ||
        gender.value.isEmpty) {
      Get.snackbar('Error', 'الرجاء ملئ كامل الحقول');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      Map<String, dynamic> payload = {
        'movement_type_id': selectedRequestType.value,
        'start_latitude': position.latitude,
        'start_longitude': position.longitude,
        'start_address': locationController.text,
        'destination_address': destinationController.text,
        'gender': gender.value,
      };

      final response = await http.post(
        Uri.parse('${Url.url}api/movements'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.value}'
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        String movementId = responseBody['data']['movement_id'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('movement_id', movementId);

        Get.snackbar(
          'Success',
          'Your request has been created successfully',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
        );

        Get.offAll(() => const Bottombar());
      } else if (response.statusCode == 429) {
        Get.snackbar(
          'Error',
          'You have recently requested a car. Please wait a moment while your request is being processed',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 5),
          colorText: Colors.white,
        );
      } else {
        log('Failed to send location data. Status code: ${response.statusCode}');
        log('Response: ${response.body}');
      }
    } catch (e) {
      log('Error occurred while sending location data: $e');
    }
  }

  // الحصول على الاتجاهات بين نقطتين
  Future<void> getDirections(LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleMapsApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          // استخراج المسافة
          distance.value =
              data['routes'][0]['legs'][0]['distance']['value'] / 1000;

          // استخراج نقاط المسار
          List<PointLatLng> points = PolylinePoints()
              .decodePolyline(data['routes'][0]['overview_polyline']['points']);
          polylineCoordinates.assignAll(points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList());
        } else {
          Get.snackbar(
              'Error', 'Failed to fetch directions: ${data['status']}');
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch directions');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error occurred: $e');
    }
  }
}
