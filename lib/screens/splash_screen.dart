import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('.... loading ')
          ],
        ),
      ),
    );
  }
  
}