import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tawsella_final/Pages/Requests/data/reqwest_data.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class OrderDetailsPage extends StatefulWidget {
  final String from;
  final String to;
  final String tybe;
  final String gender;
  final double price;
  final Position startPosition;
  final Position endPosition;

  const OrderDetailsPage({
    super.key,
    required this.from,
    required this.to,
    required this.tybe,
    required this.gender,
    required this.price,
    required this.startPosition,
    required this.endPosition,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String, dynamic> responseData = {};
  double price1 = 0;
  String payment1 = '';
  double price2 = 0;
  String payment2 = '';
  double kmdis = 0;
  Future<double> calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    return distanceInMeters / 1000; // Convert meters to km
  }

  inject() async {
    responseData = await getkmprice();
    price1 = responseData['data']?['price1'] ?? 0;
    payment1 = responseData['data']?['payment1'] ?? "";
    price2 = responseData['data']?['price2'] ?? 0;
    payment2 = responseData['data']?['payment2'] ?? "";
    kmdis = await calculateDistance(
      widget.startPosition.latitude,
      widget.startPosition.longitude,
      widget.endPosition.latitude,
      widget.endPosition.longitude,
    );
    print(kmdis);
    price1 = price1 * kmdis;

    price2 = price2 * kmdis;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      inject();
    });
  }

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
          _buildInfoCard("التوجه من", widget.from, Icons.location_on),
          _buildInfoCard("التوجه إلى", widget.to, Icons.location_on),
          _buildInfoCard("نوع الطلب", widget.tybe, Icons.pedal_bike),
          _buildInfoCard("جنس السائق", widget.gender, Icons.person),
          // _buildInfoCard("الوقت لوصول السائق", "07:00 دقيقة", Icons.access_time,
          //     isBlue: true),
          _buildInfoCard("المسافة المحسوبة", "${kmdis.toStringAsFixed(2)} KM",
              Icons.calculate_rounded,
              isBlue: false),
          _buildInfoCard(
              "السعر المتوقع للرحلة",
              '${price1.toStringAsFixed(2)}$payment1 / ${price2.toStringAsFixed(2)}$payment2',
              Icons.attach_money,
              isBlue: true),
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
