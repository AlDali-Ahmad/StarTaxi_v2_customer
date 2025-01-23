import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tawsella_final/auth/Controller/UserPreferences.dart';
import 'package:tawsella_final/NotificationController.dart';
import 'package:tawsella_final/Pages/notification.dart';
import 'package:tawsella_final/Pages/pricesPage.dart';
import 'package:tawsella_final/Pages/profile.dart';
import 'package:tawsella_final/Pages/requests/View/requests_page.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class Bottombar extends StatefulWidget {
  const Bottombar({Key? key}) : super(key: key);

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  void playNotificationSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('sound/notification.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      log('Error playing sound: $e');
    }
  }

  int currentIndex = 0;

  late WebSocketChannel _channel;
  String? id;
  String? _token;
  List<String> notifications = [];
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts =
      5; // Limit for the number of reconnect attempts
  final Duration _reconnectDelay =
      const Duration(seconds: 5); // Delay before reconnecting

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, String?> userInfo = await UserPreferences.getUserInfo();

    setState(() {
      id = userInfo['id'];
      _token = userInfo['token'];
      if (id != null && _token != null) {
        _connectToWebSocket();
      } else {
        log('Failed to load user data: id or token is null');
      }
    });
  }

  void _connectToWebSocket() {
    _reconnectAttempts = 0; // Reset the reconnect attempts
    _channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1',
      ),
    );

    _channel.stream.listen(
      (event) async {
        log('Received event: $event');
        if (event.contains('connection_established')) {
          final decodedEvent = jsonDecode(event);
          final decodeData = jsonDecode(decodedEvent['data']);
          final socketId = decodeData['socket_id'];
          log('Socket ID: $socketId'); 

          const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
          final authResponse = await http.post(
            Uri.parse(authUrl),
            headers: {
              'Authorization': 'Bearer $_token',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(
              {'channel_name': 'customer.${id}', 'socket_id': socketId},
            ),
          );

          if (authResponse.statusCode == 200) {
            final authData = jsonDecode(authResponse.body);
            log('Auth data: $authData');
            _channel.sink.add(jsonEncode({
              "event": "pusher:subscribe",
              "data": {
                "channel": "customer.${id}",
                "auth": authData['auth'].toString(),
              },
            }));
          } else {
            log('Failed to authenticate: ${authResponse.body}');
          }
        }
        try {
          final decodedEvent = jsonDecode(event);
          log('Decoded event: $decodedEvent');
          if (decodedEvent is Map<String, dynamic>) {
            log('Decoded event:222 $decodedEvent');

            if (decodedEvent.containsKey('event') &&
                decodedEvent['event'] == 'acceptRequest') {
              log('Decoded event:333 $decodedEvent');
              if (mounted) {
                setState(() {
                  final data = jsonDecode(decodedEvent['data']);

                  if (data != null &&
                      data['customer'] != null &&
                      data['driver'] != null) {
                    final customer = data['customer'];
                    // بيانات الزبون
                    final driverName =
                        customer['driver']['name'] ?? 'غير متوفر';
                    final driverPhone =
                        customer['driver']['phone_number'] ?? 'غير متوفر';
                    // int driverGender =
                    // customer['driver']['phone_number'] ?? 'غير متوفر';
                    // customer['driver']['gender'] ?? 'غير متوفر';

                    // إضافة إشعار جديد مع تفاصيل الزبون والسائق
                    Get.find<NotificationController>().addNotification(
                      driverName,
                      driverPhone, /*driverGender*/
                    );
                    Get.snackbar(
                      'Your request has been accepted, we have sent you the driver:'
                          .tr,
                      '${'driverName'.tr} $driverName - ${'driverPhone'.tr} $driverPhone',
                      colorText: AppColors.white,
                    );
                    playNotificationSound();
                  } else {
                    log('بيانات غير كافية لعرض الإشعار');
                  }
                });
              }
            }
          }
        } catch (e) {
          log('Error decoding event: $e');
        }
      },
      onError: (error) {
        log('WebSocket error: $error');
      },
      onDone: () {
        log('WebSocket connection closed');
        _reconnect();
      },
      cancelOnError: true,
    );
  }

  void _reconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      print('Attempting to reconnect... ($_reconnectAttempts)');
      Future.delayed(_reconnectDelay, () {
        _connectToWebSocket();
      });
    } else {
      print('Max reconnect attempts reached. Giving up.');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  final List<Widget> pages = [
    const Requests(),
    MovementTypesPage(),
    MyOrdersPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Stack(
        children: [
          pages[currentIndex],
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isKeyboardVisible
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: SizedBox(
                width: 50.w,
                height: 50.h,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blue1,
                        AppColors.blue1,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        // Action for the floating button
                      });
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: const Icon(
                      Icons.car_repair_outlined,
                      color: AppColors.textField_color,
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        shape: const CircularNotchedRectangle(),
        elevation: 0,
        height: 68.h,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 239, 234, 234),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Column(
                  children: [
                    const Icon(Icons.home_outlined),
                    const SizedBox(height: 2),
                    CustomText(
                      text: 'Home'.tr,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: currentIndex == 0
                          ? AppColors.blue1
                          : AppColors.iconColor,
                    ),
                  ],
                ),
                color:
                    currentIndex == 0 ? AppColors.blue1 : AppColors.iconColor,
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Column(
                  children: [
                    const Icon(Icons.price_change_outlined),
                    const SizedBox(height: 2),
                    CustomText(
                      text: 'Prices'.tr,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: currentIndex == 1
                          ? AppColors.blue1
                          : AppColors.iconColor,
                    ),
                  ],
                ),
                color:
                    currentIndex == 1 ? AppColors.blue1 : AppColors.iconColor,
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
              ),
              const SizedBox(width: 70),
              IconButton(
                icon: Column(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(height: 2),
                    CustomText(
                      text: 'My Orders'.tr,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: currentIndex == 2
                          ? AppColors.blue1
                          : AppColors.iconColor,
                    ),
                  ],
                ),
                color:
                    currentIndex == 2 ? AppColors.blue1 : AppColors.iconColor,
                onPressed: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
              ),
              IconButton(
                icon: Column(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(height: 2),
                    CustomText(
                      text: 'My Profile'.tr,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: currentIndex == 3
                          ? AppColors.blue1
                          : AppColors.iconColor,
                    ),
                  ],
                ),
                color:
                    currentIndex == 3 ? AppColors.blue1 : AppColors.iconColor,
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
