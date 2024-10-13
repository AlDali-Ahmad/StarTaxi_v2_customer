import 'package:flutter/material.dart';
import 'package:tawsella_final/components/custom_text.dart';
import 'package:tawsella_final/utils/app_colors.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: AppColors.orange1,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.BackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(text: "ChatS creen",color: Colors.amber,),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                SizedBox(height: 10),
                _buildSenderMessage("Hi, I'd like to place an order for a burger, Please", '09:25 AM'),
                SizedBox(height: 10),
                _buildReceiverMessage(
                    "Sure, We're thrilled you chose us. What Type of burger are you in the mood for today?", '09:25 AM'),
              ],
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  // Sender Message (User)
  Widget _buildSenderMessage(String message, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // CircleAvatar(
          //   radius: 20,
          //   backgroundImage: AssetImage('assets/images/user_avatar.png'), // Replace with your asset image
          // ),
          // SizedBox(width: 10),
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

  // Receiver Message (Admin/Restaurant)
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

  // Message Input Field
  Widget _buildMessageInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
              // Add your message sending logic here
            },
          ),
        ],
      ),
    );
  }
}
