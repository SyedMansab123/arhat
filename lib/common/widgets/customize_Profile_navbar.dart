// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously, unnecessary_import

import 'package:arhat/screens/Dashboard/account_setting.dart';
import 'package:arhat/screens/Welcome/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Navbar extends StatefulWidget {
  String accName;
  String accEmail;
  Navbar({super.key, required this.accName, required this.accEmail});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.accName),
            accountEmail: Text(widget.accEmail),
            currentAccountPicture: const CircleAvatar(
              child: ClipOval(
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
                // Image(image: AssetImage('assets/frontlogo.jpeg'),width: 90,height: 90,fit: BoxFit.cover,),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 3, 59, 20),
              // image: DecorationImage(image: AssetImage("assets\frontlogo.jpeg"),fit:BoxFit.cover)
            ),
          ),
          // ListTile(
          // leading: const Icon(Icons.assessment),
          // title: const Text("DashBoard"),
          // onTap: () {
          //    Navigator.push(context, MaterialPageRoute(builder:(context)=>const NavBarDashboard()));

          // },),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Account Setting"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountSetting()));
            },
          ),
          const Divider(),
          //  ListTile(
          // leading: const Icon(Icons.favorite),
          // title: const Text("Favourite"),
          // onTap: () {

          // },),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sign Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WelcomeScreen();
                }));
              });
            },
          )
        ],
      ),
    );
  }
}
