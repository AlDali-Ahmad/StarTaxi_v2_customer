// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:tawsella_final/utils/url.dart';
// import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';

// class TimerPage extends StatefulWidget {
//   const TimerPage({Key? key}) : super(key: key);

//   @override
//   State<TimerPage> createState() => _TimerPageState();
// }

// class _TimerPageState extends State<TimerPage> {
//   late String phoneNumber;

//   Future<Map<String, dynamic>> fetchData() async {
//     final response = await http.get(Uri.parse('${Url.url}api/get-car'));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = jsonDecode(response.body);
//       return data;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<String?> fetchPhoneNumber() async {
//     try {
//       final response = await http.get(Uri.parse('${Url.url}api/phone'));
//       if (response.statusCode == 200) {
//         String responseData = response.body;
//         return responseData;
//       } else {
//         throw Exception('Failed to load phone number');
//       }
//     } catch (e) {
//       print('Error fetching phone number: $e');
//       return null;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchPhoneNumber().then((value) {
//       setState(() {
//         phoneNumber = value ?? '';
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppColors.BackgroundColor,
//         title: const Text(
//           'Order Details',
//           style: TextStyle(color: Colors.amber),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back, color: AppColors.orange1),
//         ),
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: fetchData(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
//               );
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}',
//                   style: const TextStyle(color: Colors.orange));
//             } else {
//               return ListView.builder(
//                 itemCount: 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     color: AppColors.BackgroundColor,
//                     margin: const EdgeInsets.all(16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                       side: BorderSide(color: AppColors.orange2),
//                     ),
//                     elevation: 5,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Type: ${snapshot.data['data']['type']}',
//                             style: const TextStyle(
//                                 color: AppColors.orange2, fontSize: 18),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Price: ${snapshot.data['data']['price']}',
//                             style: const TextStyle(
//                                 color: AppColors.orange2, fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Currency: ${snapshot.data['data']['payment']}',
//                             style: const TextStyle(
//                                 color: AppColors.orange2, fontSize: 16),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Description: ${snapshot.data['data']['description']}',
//                             style: const TextStyle(
//                                 color: AppColors.orange2, fontSize: 16),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final phoneNumber = await fetchPhoneNumber();
//           final whatsapp = Uri.parse('https://wa.me/$phoneNumber');
//           launchUrl(whatsapp);
//         },
//         backgroundColor: Colors.orange,
//         child: const Icon(Icons.message, color: Colors.black),
//       ),
//       backgroundColor: Colors.black,
//     );
//   }
// }
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
      print('Error fetching phone number: $e');
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
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
            hintStyle: TextStyle(color: Colors.amber),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: AppColors.orange1),
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
                                  AppColors.orange1),
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
                                      color: AppColors.orange1,
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
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, bottom: 100),
                          child: Container(
                            width: double.infinity, // اجعل عرض الحاوية بالكامل
                            child: Text(
                              'In order to request a car for a period of time, contact the number'
                                  .tr,
                              textAlign: TextAlign.center, // مركز النص
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
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
        backgroundColor: Colors.orange,
        child: const Icon(Icons.message, color: Colors.black),
      ),
    );
  }
}
