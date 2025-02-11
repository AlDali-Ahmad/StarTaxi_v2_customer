// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:tawsella_final/utils/url.dart';

// class MovementTypesPage extends StatefulWidget {
//   @override
//   _MovementTypesPageState createState() => _MovementTypesPageState();
// }

// class _MovementTypesPageState extends State<MovementTypesPage> {
//   List<Map<String, dynamic>> movements = [];
//   List<Map<String, dynamic>> filteredMovements = [];
//   String searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchMovements();
//   }

//   Future<void> fetchMovements() async {
//     final apiUrl = '${Url.url}api/movement-types';
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['data']['movements'] != null) {
//           setState(() {
//             movements =
//                 List<Map<String, dynamic>>.from(jsonData['data']['movements'])
//                     .map((item) => {
//                           'type': item['type'],
//                           'price': item['price'],
//                         })
//                     .toList();
//             filteredMovements = movements;
//           });
//         } else {
//           print('No data found');
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   void filterSearchResults(String query) {
//     setState(() {
//       searchQuery = query;
//       filteredMovements = movements.where((item) {
//         final type = item['type'].toLowerCase();
//         final searchLower = query.toLowerCase();
//         return type.contains(searchLower);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.BackgroundColor,
//         title: TextField(
//           onChanged: filterSearchResults,
//           decoration: const InputDecoration(
//             hintText: 'Search for the type of movement...',
//             hintStyle: TextStyle(color: Colors.amber),
//             border: InputBorder.none,
//             icon: Icon(Icons.search, color: AppColors.orange1),

//           ),
//            style: const TextStyle(color: Colors.white),
//         ),
//         automaticallyImplyLeading: false,
//         elevation: 4.0,
//       ),
// body: Padding(
//   padding: const EdgeInsets.all(16.0),
//   child: filteredMovements.isEmpty
//       ? searchQuery.isNotEmpty
//           ? const Center(
//               child: Text(
//                 'No results found',
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   color: Colors.red,
//                 ),
//               ),
//             )
//           : const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange1),
//               ),
//             )
//       : ListView.builder(
//           itemCount: filteredMovements.length,
//           itemBuilder: (context, index) {
//             final movement = filteredMovements[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8.0),
//               elevation: 4.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(16.0),
//                 title: Text(
//                   'Destination: ${movement['type']}',
//                   style: const TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.orange1,
//                   ),
//                 ),
//                 subtitle: Text(
//                   'Price: ${movement['price']}',
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     color: Colors.black54,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:developer';
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
          log(jsonData['data']['movements'].toString());
          setState(() {
            movements =
                List<Map<String, dynamic>>.from(jsonData['data']['movements'])
                    .map((item) => {
                          'type': item['type'],
                          'price1': item['price1'],
                          'price2': item['price2'],
                          'payment1': item['payment1'],
                          'payment2': item['payment2'],
                        })
                    .toList();
            filteredMovements = movements;
          });
        } else {
          log('No data found');
        }
      } else {
        log('Request failed with status: ${response.statusCode}');
        log('Request failed: ${response.body}');
      }
    } catch (e) {
      log('Error fetching data: $e');
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
        backgroundColor: AppColors.textColor,
        title: TextField(
          onChanged: filterSearchResults,
          decoration: InputDecoration(
            hintText: 'search_movement_type'.tr,
            hintStyle: const TextStyle(color: Colors.white),
            border: InputBorder.none,
            icon: const Icon(Icons.search, color: AppColors.white),
          ),
          style: const TextStyle(color: Colors.white),
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
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.orange1),
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
                            color: AppColors.orange1,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (movement['price1'] != null)
                              Row(
                                children: [
                                  Text(
                                    '${'price'.tr}:  ${movement['payment1']} ${movement['price1']}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(
                              width: 30,
                            ),
                            if (movement['price2'] != null)
                              Row(
                                children: [
                                  Text(
                                    '${'price'.tr}:${movement['payment2']} ${movement['price2']}',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )),
                  );
                },
              ),
      ),
    );
  }
}






// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:tawsella_final/utils/url.dart';

// class MovementTypesPage extends StatefulWidget {
//   @override
//   _MovementTypesPageState createState() => _MovementTypesPageState();
// }

// class _MovementTypesPageState extends State<MovementTypesPage> {
//   List<Map<String, dynamic>> movementTypes = [];
//   List<Map<String, dynamic>> filteredMovementTypes = [];
//   String searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchMovementTypes();
//   }

//   Future<void> fetchMovementTypes() async {
//     final apiUrl = '${Url.url}api/movement-types';
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['data'] != null) {
//           setState(() {
//             movementTypes = List<Map<String, dynamic>>.from(jsonData['data']['movementTypes'])
//                 .map((item) => {
//                       'type': item['type'],
//                       'price': item['price'],
//                       'payment': item['payment'],  // إضافة العملة
//                     })
//                 .toList();
//             filteredMovementTypes = movementTypes; // Initialize filtered list
//           });
//         } else {
//           print('No data found');
//         }
//       } else {
//         print('Request failed with status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   void filterSearchResults(String query) {
//     setState(() {
//       searchQuery = query;
//       filteredMovementTypes = movementTypes.where((item) {
//         final type = item['type'].toLowerCase();
//         final searchLower = query.toLowerCase();
//         return type.contains(searchLower);
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.BackgroundColor,
//         title: TextField(
//           onChanged: filterSearchResults,
//           decoration: const InputDecoration(
//             hintText: 'Search for the type of movement...',
//             hintStyle: TextStyle(color: Colors.amber),
//             border: InputBorder.none,
//             icon: Icon(Icons.search, color: AppColors.orange1),
//           ),
//         ),
//         automaticallyImplyLeading: false,
//         elevation: 4.0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: filteredMovementTypes.isEmpty
//             ? const Center(
//                 child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange1),
//               ))
//             : ListView.builder(
//                 itemCount: filteredMovementTypes.length,
//                 itemBuilder: (context, index) {
//                   final mt = filteredMovementTypes[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     elevation: 4.0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(16.0),
//                       title: Text(
//                         'Destination: ${mt['type']}',
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                           color: AppColors.orange1,
//                         ),
//                       ),
//                       subtitle: Text(
//                         'Price: ${mt['price']} ${mt['payment']}',  // عرض العملة مع السعر
//                         style: const TextStyle(
//                           fontSize: 16.0,
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
