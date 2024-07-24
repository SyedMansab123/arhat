import 'package:arhat/data/services/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices  splashScreens = SplashServices();
  @override
  void initState() {
    
    super.initState();
    splashScreens.iswelcome(context);
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:SizedBox(
              height: 250,
              width: 190,
              child: Image(
                  image: AssetImage("assets/frontlogo.jpeg"), fit: BoxFit.cover),
            ),
      ),

    );
  }
}