



// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customized_button.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:arhat/data/services/firebase_auth_service.dart';
import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:arhat/screens/SignUp_Login/forgot_password.dart';
import 'package:arhat/screens/SignUp_Login/signup_screen.dart';
import 'package:arhat/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Welcome Back! Glad \nto see you again",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 59, 20),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  CustomizedTextfield(
                    myController: _emailController,
                    hintText: "Enter your Email",
                    isPassword: false,
                    text: "Enter Email is Required",
                    helperText: "Enter Email e.g abc@gmail.com",
                  ),
                  CustomizedTextfield(
                    myController: _passwordController,
                    hintText: "Enter your Password",
                    text: "Enter Password is Required",
                    isPassword: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ForgotPassword()));
                        },
                        child: const Text("Forgot Password?",
                            style: TextStyle(
                              color: Color(0xff6A707C),
                              fontSize: 15,
                            )),
                      ),
                    ),
                  ),
                  CustomizedButton(
                    buttonTexts: "Login",
                    buttonColor: const Color.fromARGB(255, 3, 59, 20),
                    textColor: Colors.white,
                    loading:loading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          setState(() {
                            loading = true;
                          });
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          final user =
                              await FirebaseService().signIn(email, password);
                          if (user != null) {
                            loading = false;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Dashboard(),
                              ),
                            );
                          } else {
                            setState(() {
                              loading =false;
                            });
                          }
                        } on FirebaseException catch (e) {
                          Utils().toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Text(" Invalid Username or password. Please register again or make sure that username and password is correct"),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.grey,
                        ),
                        const Text("Or Login with"),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 8, 8, 8.0),
                    child: Row(
                      children: [
                        const Text("Don't have an account?",
                            style: TextStyle(
                              color: Color(0xff1E232C),
                              fontSize: 15,
                            )),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          ),
                          child: const Text("  Register Now",
                            style: TextStyle(
                              color: Color(0xff35C2C1),
                              fontSize: 15,
                            )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



