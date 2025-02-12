import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/pages/drivers_ready/controller/drivers_ready_controller.dart';
import 'package:tawsella_final/utils/url.dart';

class DriversReadyPage extends StatelessWidget {
  final DriverController driverController = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("السائقين المتاحين"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (driverController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (driverController.driversList.isEmpty) {
          return const Center(child: Text("لا يوجد سائقين متاحين حاليًا"));
        }

        return ListView.builder(
          itemCount: driverController.driversList.length,
          itemBuilder: (context, index) {
            var driver = driverController.driversList[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  //  NetworkImage(
                  //               '${Url.url}${advertisements[index].image}',
                  //             ),
                  backgroundImage: NetworkImage('${Url.urlImage}${driver.avatar}'),
                  onBackgroundImageError: (_, __) =>
                      const Icon(Icons.person, size: 40),
                ),
                title: Text(driver.name ?? "غير معروف"),
                subtitle: Text("العمر: ${driver.age ?? 'غير متوفر'}"),
                trailing: Text(driver.gender ?? "غير محدد"),
              ),
            );
          },
        );
      }),
    );
  }
}
