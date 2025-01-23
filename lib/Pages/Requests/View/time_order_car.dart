import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:tawsella_final/utils/url.dart';
import 'package:url_launcher/url_launcher.dart';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  List<Map<String, dynamic>> movementTypes = [];
  List<Map<String, dynamic>> filteredMovementTypes = [];
  String searchQuery = '';
  late String phoneNumber;

  @override
  void initState() {
    super.initState();
    fetchMovementTypes();
    fetchPhoneNumber().then((value) {
      setState(() {
        phoneNumber = value ?? '';
      });
    });
  }

  Future<String?> fetchPhoneNumber() async {
    try {
      final response = await http.get(Uri.parse('${Url.url}api/phone'));
      if (response.statusCode == 200) {
        String responseData = response.body;
        return responseData;
      } else {
        throw Exception('Failed to load phone number');
      }
    } catch (e) {
      log('Error fetching phone number: $e');
      return null;
    }
  }

  Future<void> fetchMovementTypes() async {
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
        if (jsonData['data'] != null) {
          setState(() {
            movementTypes = List<Map<String, dynamic>>.from(
                    jsonData['data']['movementTypes'])
                .map((item) => {
                      'type': item['type'],
                      'price': item['price'],
                      'payment': item['payment'],
                    })
                .toList();
            filteredMovementTypes = movementTypes;
          });
        } else {
          log('No data found');
        }
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      searchQuery = query;
      filteredMovementTypes = movementTypes.where((item) {
        final type = item['type'].toLowerCase();
        final searchLower = query.toLowerCase();
        return type.contains(searchLower);
      }).toList();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.BackgroundColor,
        title: TextField(
          onChanged: filterSearchResults,
          decoration: const InputDecoration(
            hintText: 'Search for the type of movement...',
            // hintStyle: TextStyle(color: Colors.amber),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: AppColors.blue1),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: filteredMovementTypes.isEmpty
                  ? Center(
                      child: searchQuery.isEmpty
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.blue1),
                            )
                          : Text(
                              'No results found'.tr,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.red,
                              ),
                            ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredMovementTypes.length,
                            itemBuilder: (context, index) {
                              final mt = filteredMovementTypes[index];
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16.0),
                                  title: Text(
                                    '${'destination'.tr}: ${mt['type']}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blue1,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${'price'.tr}: ${mt['price']} ${mt['payment']}',
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
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16, bottom: 100),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              'لطلب سيارة لمدة زمنية تواصل مع الادارة من خلال الزر بالأسفل.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final phoneNumber = await fetchPhoneNumber();
          final whatsapp = Uri.parse('https://wa.me/$phoneNumber');
          launchUrl(whatsapp);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.message, color: Colors.black),
      ),
    );
  }
}
