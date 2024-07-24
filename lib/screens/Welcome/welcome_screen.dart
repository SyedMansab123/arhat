// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customized_button.dart';
import 'package:arhat/screens/SignUp_Login/login_screen.dart';
import 'package:arhat/screens/SignUp_Login/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Image.asset(
                  "assets/frontlogo.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              CustomizedButton(
                buttonTexts: "Login",
                buttonColor: const Color.fromARGB(255, 3, 59, 20),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              CustomizedButton(
                buttonTexts: "Register",
                buttonColor: Colors.white,
                textColor: const Color.fromARGB(255, 3, 59, 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
