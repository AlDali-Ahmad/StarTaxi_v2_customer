import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tawsella_final/Pages/Requests/Controller/order_car_controller.dart';
import 'package:tawsella_final/components/customTextField.dart';
import 'package:tawsella_final/components/custom_loading_button.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class OrderCarPage extends StatelessWidget {
  final OrderCarController controller = Get.put(OrderCarController());

  OrderCarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        title: const Text('طلب جديد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: Obx(() => GoogleMap(
                    onTap: (LatLng latLng) {
                      if (controller.markers.length >= 2) {
                        controller.markers.removeLast();
                      }
                      controller.markers.add(Marker(
                        markerId: MarkerId("selected_location_${controller.markers.length}"),
                        position: LatLng(latLng.latitude, latLng.longitude),
                      ));
                    },
                    markers: controller.markers.toSet(),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: controller.polylineCoordinates,
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                    initialCameraPosition: controller.initialCameraPosition,
                    mapType: MapType.normal,
                    onMapCreated: (mapController) {
                      controller.mapController = mapController;
                    },
                  )),
            ),
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
                    _buildDestinationField(controller),
                    const SizedBox(height: 10),
                    _buildLocationField(controller),
                    const SizedBox(height: 16),
                    _buildRequestTypeAndGenderFields(controller),
                    const SizedBox(height: 20),
                    _buildSubmitButton(size, controller),
                    const SizedBox(height: 10),
                    _buildShowRouteButton(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationField(OrderCarController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CustomText(
              text: 'اين تريد الذهاب ',
              color: AppColors.white,
            ),
            CustomText(
              text: '(optional)'.tr,
              fontSize: 12,
              color: AppColors.iconColor,
            ),
          ],
        ),
        const SizedBox(height: 5),
        CustomTextField(
          controller: controller.destinationController,
          hintText: '',
          iconData: Icons.car_repair,
        ),
      ],
    );
  }

  Widget _buildLocationField(OrderCarController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CustomText(
              text: 'ادخل موقعك الحالي ',
              color: AppColors.white,
            ),
            CustomText(
              text: '(optional)'.tr,
              fontSize: 12,
              color: AppColors.iconColor,
            ),
          ],
        ),
        const SizedBox(height: 5),
        CustomTextField(
          controller: controller.locationController,
          hintText: '',
          iconData: Icons.people,
        ),
      ],
    );
  }

  Widget _buildRequestTypeAndGenderFields(OrderCarController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRequestTypeDropdown(controller),
        _buildGenderDropdown(controller),
      ],
    );
  }

  Widget _buildRequestTypeDropdown(OrderCarController controller) {
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<String>(
        value: controller.selectedRequestType.value,
        items: [
          DropdownMenuItem(
            value: 't-m-t-1',
            child: Text(
              'Internal request'.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          DropdownMenuItem(
            value: 't-m-t-2',
            child: Text(
              'external request'.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            controller.selectedRequestType.value = value;
          }
        },
        decoration: _buildDropdownDecoration('Select the request type'.tr),
      ),
    );
  }

  Widget _buildGenderDropdown(OrderCarController controller) {
    return SizedBox(
      width: 150,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textField_color,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.gender.value,
            items: [
              DropdownMenuItem(
                value: 'male',
                child: Text(
                  'Male'.tr,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              DropdownMenuItem(
                value: 'female',
                child: Text(
                  'Female'.tr,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                controller.gender.value = value;
              }
            },
            hint: Text(
              'Choose gender'.tr,
              style: const TextStyle(fontSize: 16.0, color: Colors.black26),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildDropdownDecoration(String hintText) {
    return InputDecoration(
      labelText: hintText,
      labelStyle: const TextStyle(color: Colors.black26),
      filled: true,
      fillColor: AppColors.textField_color,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
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
    );
  }

  Widget _buildSubmitButton(Size size, OrderCarController controller) {
    return LoadingButtonWidget(
      onPressed: () {
        if (controller.token.value != null && controller.token.value.isNotEmpty) {
          controller.sendLocationToDatabase();
        } else {
          Get.snackbar('Error', 'تأكد من تسجيل الدخول أولاً');
        }
      },
      text: 'ارسل',
      width: size.width / 1.7,
    );
  }

  Widget _buildShowRouteButton(OrderCarController controller) {
    return ElevatedButton(
      onPressed: () async {
        if (controller.markers.length >= 2) {
          LatLng origin = controller.markers[0].position;
          LatLng destination = controller.markers[1].position;
          await controller.getDirections(origin, destination);
          Get.snackbar(
            'Distance',
            'Estimated distance: ${controller.distance.value.toStringAsFixed(2)} km',
            snackPosition: SnackPosition.BOTTOM,
          );
          
        } else {
          Get.snackbar('Error', 'Please select both origin and destination');
        }
      },
      child: const Text('Show Route'),
    );
  }
}