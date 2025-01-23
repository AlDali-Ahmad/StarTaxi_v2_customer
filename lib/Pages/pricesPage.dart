import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';
import 'package:get/get.dart'; // Import for translation

class MovementTypesPage extends StatefulWidget {
  @override
  _MovementTypesPageState createState() => _MovementTypesPageState();
}

class _MovementTypesPageState extends State<MovementTypesPage> {
  List<Map<String, dynamic>> movements = [];
  List<Map<String, dynamic>> filteredMovements = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchMovements();
  }

  Future<void> fetchMovements() async {
    final apiUrl = '${Url.url}api/movement-types';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data']['movements'] != null) {
          setState(() {
            movements =
                List<Map<String, dynamic>>.from(jsonData['data']['movements'])
                    .map((item) => {
                          'type': item['type'],
                          'price': item['price'],
                        })
                    .toList();
            filteredMovements = movements;
          });
        } else {
          print('No data found');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      searchQuery = query;
      filteredMovements = movements.where((item) {
        final type = item['type'].toLowerCase();
        final searchLower = query.toLowerCase();
        return type.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        title: TextField(
          onChanged: filterSearchResults,
          decoration: const InputDecoration(
            hintText: 'ابحث عن نوع الحركة',
            // hintStyle: const TextStyle(color: Colors.amber),
            border: InputBorder.none,
            icon: Icon(Icons.search,),
          ),
          // style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: filteredMovements.isEmpty
            ? searchQuery.isNotEmpty
                ? Center(
                    child: Text(
                      'no_results'.tr,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                      ),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue1),
                    ),
                  )
            : ListView.builder(
                itemCount: filteredMovements.length,
                itemBuilder: (context, index) {
                  final movement = filteredMovements[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        '${'destination'.tr}: ${movement['type']}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue1,
                        ),
                      ),
                      subtitle: Text(
                        '${'price'.tr}: ${movement['price']}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}