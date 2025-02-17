import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/Pages/Requests/View/order_confirm.dart';
import 'package:tawsella_final/Pages/bottombar.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/components/custom_snackbar.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';

class OrderCarPage extends StatefulWidget {
  const OrderCarPage({Key? key}) : super(key: key);

  @override
  State<OrderCarPage> createState() => _OrderCarPageState();
}

class _OrderCarPageState extends State<OrderCarPage> {
  GoogleMapController? gms;
  List<Marker> markers = [];
  Position? startposition;
  Position? endposition;

  Future<void> initalLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    print("initalLocation");

    // التحقق مما إذا كانت خدمات الموقع مفعلة
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Location services are disabled.');
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      print("position");
      print(position);
      startposition = position;
      // إضافة Marker على الخريطة وتحريك الكاميرا إلى الموقع الحالي
      markers.add(Marker(
          markerId: const MarkerId("2"),
          position: LatLng(position.latitude, position.longitude)));
      gms!.animateCamera(CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude)));
      // startLatitude = position.latitude;
      // startLongitude = position.longitude;
      log('***********************');
      log('${position.latitude}');
      log('${position.longitude}');
      log('***************************');
      setState(() {});
    }
  }

  @override
  void initState() {
    initalLocation();
    // initalStram();
    super.initState();
  }

  @override
  void dispose() {
    // positionStream!.cancel();
    super.dispose();
  }

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(36.586038, 37.044871),
    zoom: 10.4746,
  );
  final TextEditingController destination = TextEditingController();
  final TextEditingController location = TextEditingController();

  String? _gender;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          shadowColor: AppColors.orange1,
          backgroundColor: AppColors.textColor,
          title: Text(
            'طلب تكسي',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
            ),
          ),
          leading: const BackButton(
            color: AppColors.white,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                height: 400.h,
                child: GoogleMap(
                  onTap: (LatLng latLng) async {
                    log('**************');
                    log('${latLng.latitude}');
                    log('${latLng.longitude}');
                    log('**************');
                    markers.add(Marker(
                        markerId: const MarkerId("1"),
                        position: LatLng(latLng.latitude, latLng.longitude)));
                    endposition = Position(
                        longitude: latLng.longitude,
                        latitude: latLng.latitude,
                        timestamp: DateTime.now(),
                        accuracy: 1,
                        altitude: 0,
                        altitudeAccuracy: 0,
                        heading: 0,
                        headingAccuracy: 0,
                        speed: 0,
                        speedAccuracy: 0);
                    setState(() {});
                  },
                  markers: markers.toSet(),
                  initialCameraPosition: cameraPosition,
                  mapType: MapType.normal,
                  onMapCreated: (mapController) {
                    gms = mapController;
                  },
                )),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.textColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: 'Select your destination'.tr,
                          fontSize: 15,
                          color: AppColors.white,
                        ),
                        CustomText(
                          text: '(optional)'.tr,
                          fontSize: 12,
                          color: AppColors.iconColor,
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: destination,
                      hintText: 'Select target destination'.tr,
                      iconData: Icons.car_repair,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        CustomText(
                          text: 'Select the current location'.tr,
                          fontSize: 15,
                          color: AppColors.white,
                        ),
                        CustomText(
                          text: '(optional)'.tr,
                          fontSize: 12,
                          color: AppColors.iconColor,
                        ),
                      ],
                    ),
                    CustomTextField(
                      controller: location,
                      hintText: 'Select your current location'.tr,
                      iconData: Icons.people,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 150.w,
                              child: DropdownButtonFormField<String>(
                                  value: _selectedValue,
                                  items: [
                                    DropdownMenuItem(
                                      value: 't-m-t-1',
                                      child: Text(
                                        'Internal request'.tr,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value: 't-m-t-2',
                                      child: Text(
                                        'external request'.tr,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedValue = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: _selectedValue != null
                                        ? ''
                                        : 'Select the request type'.tr,
                                    labelStyle:
                                        const TextStyle(color: Colors.black26),
                                    filled: true,
                                    fillColor: AppColors.textField_color,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                  ),
                                  dropdownColor: AppColors.textField_color),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 150.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.textField_color,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _gender,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'male',
                                        child: Text(
                                          'Male'.tr,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'female',
                                        child: Text(
                                          'Female'.tr,
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _gender = value!;
                                      });
                                    },
                                    hint: Text(
                                      'Choose gender'.tr,
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black26),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    isExpanded: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    LoadingButtonWidget(
                      onPressed: () {
                        print(startposition);
                        print(endposition);
                        if (startposition != null && endposition != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(
                                from: location.text,
                                to: destination.text,
                                gender: _gender ?? '',
                                tybe: (_selectedValue == 't-m-t-1')
                                    ? 'Internal request'.tr
                                    : 'external request'.tr,
                                price: 10,
                                startPosition: startposition!,
                                endPosition: endposition!,
                                movementtypeid: _selectedValue ?? '',
                              ),
                            ),
                          );
                        } else {
                          if (startposition == null) {
                            CustomSnackbar.show(
                              context,
                              'الرجاء تفيل خدمة الموقع',
                            );
                          } else {
                            CustomSnackbar.show(
                              context,
                              'الرجاء تحديد الوجهة على الخريطة',
                            );
                          }
                        }
                      },
                      text: 'اطلب الآن',
                      width: size.width / 1.7,
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
