
import 'dart:async';
import 'package:arhat/screens/Welcome/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashServices{

  void iswelcome( BuildContext context)
  {
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const WelcomeScreen()));
     });
    
  }
}