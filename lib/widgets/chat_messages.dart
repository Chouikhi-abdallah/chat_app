import 'package:chat_app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  final authenticatedUser=FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',descending: true).snapshots(),
     builder: (ctx,chatSnaphots){
      if(chatSnaphots.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
        
      }
      if(!chatSnaphots.hasData || chatSnaphots.data!.docs.isEmpty){
        return Center(
          child: Text('No messages'),
        );

      }
      if(chatSnaphots.hasError){
        return Center(child: Text("Error retrivieng the messages"),);
      }
      final loadedMessages=chatSnaphots.data!.docs;

      return ListView.builder(
        padding: EdgeInsets.only(
          bottom:100,
          left: 13,
          right:13,

        ),
        reverse: true,
        
        itemBuilder:(ctx,index){
          final chatMessages=loadedMessages[index].data();
          final nexchatMessage=index+1<loadedMessages.length ? loadedMessages[index+1].data():null;
          final currentMessageUserId=chatMessages['userId'];
          final nexMessageUserId=nexchatMessage!=null ? nexchatMessage['userId']:null;

          final nextUserISsame= nexMessageUserId == currentMessageUserId;

          if(nextUserISsame){
            return MessageBubble.next(message: chatMessages['text'], isMe: authenticatedUser!.uid == currentMessageUserId);
          }
          else{
            return MessageBubble.first(username: chatMessages['username'], message: chatMessages['text'], isMe: authenticatedUser!.uid == currentMessageUserId);
          }

        },
        itemCount: loadedMessages.length, );

     }
     );
  
  }
  
}