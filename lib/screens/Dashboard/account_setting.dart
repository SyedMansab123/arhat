// ignore_for_file: non_constant_identifier_names

import 'package:arhat/data/services/firebase_auth_service.dart';
import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _displayName = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userdata =
            await _firestore.collection("users").doc(user.uid).get();
        setState(() {
          _displayName = userdata['username'];
          _email = userdata['email'];
        });
      }
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newDisplayName = _displayName;
        String newEmail = _email;

        return AlertDialog(
          title: const Text('Update Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newDisplayName = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'New User Name',
                  ),
                ),
                const SizedBox(height: 10),
                // TextField(
                //   onChanged: (value) {
                //     newEmail = value;
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'New Email',
                //   ),
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: () {
                _updateDetails(newDisplayName, newEmail);
                Navigator.of(context).pop();
              },
              child: const Text('Update',style: TextStyle(color: Colors.green),),
            ),
          ],
        );
      },
    );
  }

  void _updateDetails(String newDisplayName, String newEmail) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).update({
          'username': newDisplayName,
          'email': newEmail,
        });
        setState(() {
          _displayName = newDisplayName;
          _email = newEmail;
        });
        Utils().toastMessage('Details updated successfully');
      }
    } catch (e) {
      Utils().toastMessage('Failed to update details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings',style: TextStyle(color:  Colors.white,),),
         leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
            color: Colors.white,
            onPressed: () async {
             
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (Context) =>
                          const Dashboard()));
            },
          ),
        backgroundColor: const Color.fromARGB(255, 3, 59, 20),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          
                          padding: const EdgeInsets.all(20.0),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Align children to the center horizontally
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                child: ClipOval(
                                  child: Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showUpdateDialog();
                              },
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('User Name: ${_displayName.toUpperCase()}',style: const TextStyle(color:  Color.fromARGB(255, 3, 59, 20),)),
                              const SizedBox(
                                height: 15,
                              ),
                              Text('Email: $_email',style: const TextStyle(color:  Color.fromARGB(255, 3, 59, 20),)),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Container(
                          padding: const EdgeInsets.all(50.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .red, // Change this to the desired color
                            ),
                            onPressed: () async {
                              try {
                                bool confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Account'),
                                    content: const Text(
                                        'Are you sure you want to delete your account? This action cannot be undone.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Cancel',style: TextStyle(color: Colors.red),),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Delete',style: TextStyle(color: Colors.green),),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  String? currentUserId =
                                      _auth.currentUser!.uid;
                                  FirebaseService()
                                      .DeleteAccount("users", currentUserId);
                                }
                              } catch (e) {
                                Utils().toastMessage(
                                    'Failed to delete account: $e');
                              }
                            },
                            child: const Text('Delete Account',style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
