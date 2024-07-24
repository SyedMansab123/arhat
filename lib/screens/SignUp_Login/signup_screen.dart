// ignore_for_file: use_build_context_synchronously

import 'package:arhat/common/widgets/customized_button.dart';
import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:arhat/data/services/firebase_auth_service.dart';
import 'package:arhat/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
                    padding: EdgeInsets.all(10.0),
                    child: Text("Hello!  Register to get \nStarted",
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 59, 20),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  CustomizedTextfield(
                    myController: _usernameController,
                    hintText: "Company Name",
                    isPassword: false,
                    text: 'Enter Company Name is Required',
                  ),
                  CustomizedTextfield(
                    myController: _emailController,
                    hintText: "Email",
                    isPassword: false,
                    text: 'Enter Email is Required',
                    helperText: "Enter Email e.g abc@gmail.com",
                  ),
                  CustomizedTextfield(
                    myController: _passwordController,
                    hintText: "Password",
                    isPassword: true,
                    text: 'Enter Password is Required',
                  ),
                  CustomizedTextfield(
                    myController: _confirmPasswordController,
                    hintText: "Confirm Password",
                    isPassword: true,
                    text: 'Enter Password is Required',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomizedButton(
                    loading: loading,
                    buttonTexts: "Register",
                    buttonColor: const Color.fromARGB(255, 3, 59, 20),
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Get the text from the controllers
                        final username = _usernameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        final confirmPassword =
                            _confirmPasswordController.text.trim();

                        // Check if any field is empty
                        if (username.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty) {
                          Utils().toastMessage("Please fill in all fields.");
                          return; // Exit the method if any field is empty
                        }

                        // Check if password and confirm password match
                        if (password != confirmPassword) {
                          Utils().toastMessage("Passwords do not match.");
                          return; // Exit the method if passwords don't match
                        }

                        try {
                          setState(() {
                            loading = true;
                          });
                          final user = await FirebaseService()
                              .signUp(email, password, username);
                          if (user != null) {
                            setState(() {
                              loading = false;
                            });
                            // Navigate to Dashboard screen after successful signup
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                        } on FirebaseException catch (e) {
                          Utils().toastMessage(e.toString());
                          setState(() {
                            loading = false;
                          });
                          // debugPrint(e.message);
                        }
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.height * 0.14,
                          color: Colors.grey,
                        ),
                        const Text("Or Register with"),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.height * 0.15,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 8, 8, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Already have an account?",
                            style: TextStyle(
                              color: Color(0xff1E232C),
                              fontSize: 15,
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          child: const Text("  Login Now",
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
