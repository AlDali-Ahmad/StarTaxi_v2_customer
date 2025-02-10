import 'package:flutter/material.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class OrderDetailsPage extends StatelessWidget {
  final String from;
  final String to;
  final String tybe;
  final String gender;
  final double price;

  const OrderDetailsPage(
      {super.key,
      required this.from,
      required this.to,
      required this.tybe,
      required this.gender,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "تفاصيل الطلب",
          style: TextStyle(color: AppColors.textColor, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildInfoCard("التوجه من", from, Icons.location_on),
          _buildInfoCard("التوجه إلى", to, Icons.location_on),
          _buildInfoCard("نوع الطلب", tybe, Icons.pedal_bike),
          _buildInfoCard("جنس السائق", gender, Icons.person),
          // _buildInfoCard("الوقت لوصول السائق", "07:00 دقيقة", Icons.access_time,
          //     isBlue: true),
          // _buildInfoCard("مدة الرحلة", "16:22 دقيقة", Icons.access_time,
          //     isBlue: true),
          _buildInfoCard(
              "السعر المتوقع للرحلة", price.toString(), Icons.attach_money),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Confirm order action
              },
              child: const Text(
                "تأكيد الطلب",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon,
      {bool isBlue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.blue),
          title: Text(
            title,
            style: TextStyle(
              color: isBlue ? Colors.blue : Colors.black,
              fontWeight: isBlue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            value,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
