import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase=FirebaseAuth.instance;


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formkey=GlobalKey<FormState>();
  var _isLogin=true;
  var _entredEmail='';
  var _entredPassword='';
  var _entredUsername='';

  void _submit() async {
    final _isValid=_formkey.currentState!.validate();

    if(!_isValid){
      return;
    }
    _formkey.currentState!.save();

    if(_isLogin){
      // logic for login
      try{
      // ignore: unused_local_variable
      final userCreadential=await _firebase.signInWithEmailAndPassword(email: _entredEmail, password: _entredPassword);
      } on FirebaseAuthException catch(err){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
            err.message ?? ' Authenictation failed'
        )));
      }
    }
    else{
      try{
         final userCrendential= await _firebase.createUserWithEmailAndPassword(
        email: _entredEmail,
         password: _entredPassword);
         print(userCrendential);

         await FirebaseFirestore.instance.collection('users')
         .doc(userCrendential.user!.uid)
         .set({
          'username':_entredUsername,
          'email':_entredEmail,  
         });

      // ignore: empty_catches
      } on FirebaseAuthException catch(err){
       
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          err.message ?? 'Authentication failed '
        )));
      }

     

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('lib/images/bubble-chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          onSaved: (value){
                             _entredUsername=value!;
                          },
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.none,
                           validator: (newValue){
                             if(newValue == null || newValue.trim().isEmpty ){
                              return 'please enter a valid username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter your username here',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()
                              ),
                        ),
                        SizedBox(height:20,),
                        
                        TextFormField(
                          onSaved: (value){
                            _entredEmail=value!;

                          },
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                           validator: (newValue){
                             if(newValue == null || newValue.trim().isEmpty || !newValue.contains('@')){
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                          onChanged: (newValue) {},
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email here',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (newValue) {
                           
                          },
                         
                          autocorrect: false,
                          obscureText: true,
                          onSaved: (value){
                            _entredPassword=value!;
                          },
                          textCapitalization: TextCapitalization.none,
                          validator: (newValue){
                            if(newValue == null || newValue.length<6 || newValue.trim().isEmpty){
                              return 'Please enter a valid password with length at least 8 ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your Password here',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(onPressed: _submit, child: Text(_isLogin ? 'Login':'Sign up')),
                        TextButton(onPressed: (){
                          setState(() {
                            
                            _isLogin=!_isLogin;
                          });
                        }, child: Text(
                          _isLogin ? 'Create an account' 'Sign up':
                          'i already have an account'))
                      ],
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
