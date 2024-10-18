import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:tawsella_final/utils/url.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  // قائمة لتخزين الرسائل
  List<Map<String, String>> messages = [];

  // دالة إرسال الرسالة
  Future<void> sendMessage({
    File? media,
    String? message,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? chatId = prefs.getString('chat_id');
    String? receiverId = prefs.getString('driver_id');
    try {
      final apiUrl = '${Url.url}api/messages';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // إضافة الهيدر مع التوكين
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // إضافة المعرفات والبيانات النصية
      request.fields['chat_id'] = chatId!;
      request.fields['receiver_id'] = receiverId!;
      if (message != null && message.isNotEmpty) {
        request.fields['message'] = message;
      }
      if (media != null) {
        request.files
            .add(await http.MultipartFile.fromPath('media', media.path));
      }
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var responseData = json.decode(responseBody.body);
        print('Message sent successfully: $responseData');

        // إضافة الرسالة إلى القائمة
        setState(() {
          messages.add({
            'message': message!,
            'sender': 'user', // تحديد أن الرسالة مرسلة من المستخدم
            'time': 'Just now', // يمكن تعديل الوقت لاحقاً
          });
        });

        // إعادة تعيين حقل الإدخال بعد إرسال الرسالة
        _messageController.clear();
      } else {
        print('Failed to send message: ${responseBody.statusCode}');
        print('Failed to send message: ${responseBody.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.orange1,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.BackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: "Chat Screen",
          color: Colors.amber,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                if (message['sender'] == 'user') {
                  return _buildSenderMessage(message['message']!, message['time']!);
                } else {
                  return _buildReceiverMessage(message['message']!, message['time']!);
                }
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  // رسالة المرسل (المستخدم)
  Widget _buildSenderMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('John Smith', style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.all(12),
                constraints: BoxConstraints(maxWidth: 250),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(message),
              ),
              SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // رسالة المستقبل (المطعم/المسؤول)
  Widget _buildReceiverMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // حقل إدخال الرسائل
  Widget _buildMessageInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Write your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.orangeAccent),
            onPressed: () {
              sendMessage(message: _messageController.text);
            },
          ),
        ],
      ),
    );
  }
}
