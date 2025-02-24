import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatelessWidget {
   NewMessage({
    super.key,
  });

  
  @override
  Widget build(BuildContext context) {
    var _entredMessage='';
  final _formKey=GlobalKey<FormState>();
  
  void _submit() async {
    final isValid=_formKey.currentState!.validate();

    if(!isValid){
      return;
    }
    _formKey.currentState!.save();
     await FirebaseFirestore.instance.collection('chat').add({
      'text':_entredMessage,
      'createdAt':Timestamp.now(),
      'userId':FirebaseAuth.instance.currentUser!.uid,
      'username': (await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get()).data()!['username'],
    });
    FocusScope.of(context).unfocus();
  }
    return Container(
      width:double.infinity,
      height: 70,
      color: Colors.white,
      child: Center(
        child: Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.add_box_outlined,
            size: 30,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.camera,size: 30,)),
            IconButton(onPressed: (){}, icon: Icon(Icons.attach_file,size: 30,)),
            Container(
              width: 250,
              height: 40,
              child: Center(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value){
                      if(value!.trim().isEmpty){
                        return 'Text should not be empty';
                      }
                      return null;

                    },
                    onSaved:(newValue)=> _entredMessage=newValue!,
                    
                    
                    
                    decoration:InputDecoration(
                      hintText: 'Write something',
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        
                      )
                  
                  
                    ),
                  ),
                ),
              ),
              //decoration: ,
            ),
            IconButton(onPressed: _submit, icon: Icon(Icons.send)),
        
        
          ],
        ),
      ),
    
    
    );
  }
}