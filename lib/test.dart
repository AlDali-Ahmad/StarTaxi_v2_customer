// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:tawsella_final/Auth/Controller/UserPreferences.dart';
// import 'package:tawsella_final/utils/app_colors.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketListener extends StatefulWidget {
//   const WebSocketListener({super.key});

//   @override
//   _WebSocketListenerState createState() => _WebSocketListenerState();
// }

// class _WebSocketListenerState extends State<WebSocketListener> {
//   late WebSocketChannel _channel;
//   String _receivedMessage = 'No message received yet';
//   String? id;
//   String? _token;

//   @override
//   void initState() {
//     super.initState();
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     Map<String, String?> userInfo = await UserPreferences.getUserInfo();

//     setState(() {
//       id = userInfo['id'];
//       _token = userInfo['token'];
//       if (id != null && _token != null) {
//         _connectToWebSocket();
//       } else {
//         log('Failed to load user data: id or token is null');
//       }
//     });
//   }

//   void _connectToWebSocket() {
//     _channel = WebSocketChannel.connect(
//       Uri.parse(
//           'ws://10.0.2.2:8080/app/ni31bwqnyb4g9pbkk7sn?protocol=7&client=js&version=4.3.1'),
//     );

//     _channel.stream.listen(
//       (event) async {
//         log('Received event: $event');

//         // إذا تم تأسيس الاتصال
//         if (event.contains('connection_established')) {
//           final decodedEvent = jsonDecode(event);
//           final decodeData = jsonDecode(decodedEvent['data']);
//           final socketId = decodeData['socket_id'];
//           log('Socket ID: $socketId'); 

//           const authUrl = 'http://10.0.2.2:8000/api/broadcasting/auth';
//           final authResponse = await http.post(
//             Uri.parse(authUrl),
//             headers: {
//               'Authorization': 'Bearer $_token',
//               'Accept': 'application/json',
//               'Content-Type': 'application/json'
//             },
//             body: jsonEncode(
//                 {'channel_name': 'customer.${id}', 'socket_id': socketId}),
//           );

//           if (authResponse.statusCode == 200) {
//             final authData = jsonDecode(authResponse.body);
//             log('Auth data: $authData'); 
//             _channel.sink.add(jsonEncode({
//               "event": "pusher:subscribe",
//               "data": {
//                 "channel": "customer.${id}",
//                 "auth": authData['auth'].toString(),
//               },
//             }));
//           } else {
//             log('Failed to authenticate: ${authResponse.body}');
//           }
//         }

//         // معالجة الأحداث الأخرى
//         try {
//           final decodedEvent = jsonDecode(event);
//           log('Decoded event: $decodedEvent'); // طباعة الحدث المفكك
//           if (decodedEvent is Map<String, dynamic>) {
//           log('Decoded event:222 $decodedEvent'); // طباعة الحدث المفكك

//             if (decodedEvent.containsKey('event') &&
//                 decodedEvent['event'] == 'acceptRequest') {
//           log('Decoded event:333 $decodedEvent'); // طباعة الحدث المفكك
//               if (mounted) {
//                 setState(() {
//                   final data = jsonDecode(decodedEvent['data']);
//                   _receivedMessage = 'recived';
//                 });
//                 log(
//                     'Accepted request data: ${decodedEvent['data']}');
//               }
//             }
//           }
//         } catch (e) {
//           log('Error decoding event: $e');
//         }
//       },
//       onError: (error) {
//         log('WebSocket error: $error');
//       },
//       onDone: () {
//         log('WebSocket connection closed');
//       },
//       cancelOnError: true,
//     );
//   }

//   @override
//   void dispose() {
//     _channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('WebSocket Listener'),
//       ),
//       body: Center(
//         child: Text(
//           _receivedMessage,
//           style: const TextStyle(fontSize: 24, color: AppColors.white),
//         ),
//       ),
//     );
//   }
// }
