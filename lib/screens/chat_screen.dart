import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();

}

class _ChatScreenState extends State<ChatScreen> {

  void setPushNotification() async {
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission();

  final token = await fcm.getToken(); // Await the token
  print('FCM Token: $token');
}


  @override
  void initState() {
    setPushNotification();
    

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet:NewMessage(),
        
        appBar: AppBar(title: Text('chat'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          },
           icon: Icon(Icons.logout)),
        ],
        ),
        body: ChatMessages(),
      ),
    );
  
    
  }
}

