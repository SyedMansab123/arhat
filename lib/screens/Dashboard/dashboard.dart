// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously

import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Activity/Merchant/merchant_displayscreen.dart';
import 'package:arhat/screens/Dashboard/Gurahi/customer_gurahi.dart';
import 'package:arhat/screens/Dashboard/Profit%20&%20Loss/profitLoss.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:arhat/common/widgets/customize_Profile_navbar.dart';
import 'package:arhat/data/services/firebase_arhat_expense_service.dart';
import 'package:arhat/models/arhat_expense_model.dart';
import 'package:arhat/screens/Dashboard/ArathExpense/expense_display.dart';
import 'package:arhat/screens/Dashboard/Reports/view_reports.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

  var height, width;
  int bottom_nav_index = 0;

  List<void Function(BuildContext)> onTapAction = [
    (BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewsReports()),
      );
    },
    (BuildContext context) async {
      User? userId = FirebaseAuth.instance.currentUser;
      List<CustomMerchantModel> merchantData = await FirebaseMerchantService()
          .getSavedData('ArhatMerchant', userId!.uid);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (Context) => MerchantDisplayScreen(merchantData)));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ActivityButton()),
      // );
    },
    (BuildContext context) async {
      User? userId = FirebaseAuth.instance.currentUser;
      List<CustomExpenseModel> savedData = await FirebaseExpenseService()
          .getSavedData('ArhatExpense', userId!.uid);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExpenseDisplayScreen(savedData)),
      );
    },
    (BuildContext context) async {
      User? userId = FirebaseAuth.instance.currentUser;
      List<CustomMerchantModel> merchantData = await FirebaseMerchantService()
          .getSavedData('ArhatMerchant', userId!.uid);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (Context) => CustomerGurahi(merchantData)));
    },
    (BuildContext context) {
      Navigator.push(
          context, MaterialPageRoute(builder: (Context) => const MyWidget()));
    }
  ];

  List imagData = [
    "assets/viewReport.jpg",
    "assets/Activity.jpg",
    "assets/expenseManage.jpg",
    "assets/images.jpg",
    "assets/profit.jpg"
  ];

  List Titles = [
    "VIEW REPORTS",
    "Activity",
    "ARATH EXPENSE",
    "GURAHI",
    "PROFIT & LOSS"
  ];
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _scafoldKey,
        drawer: Navbar(
          accName: _displayName.toUpperCase(),
          accEmail: _email,
        ),
        body: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 3, 59, 20),
              width: width,
              height: height,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _scafoldKey.currentState?.openDrawer();
                    },
                    child: const Icon(
                      Icons.sort,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 90),
                  Container(
                    height: height * 0.05,
                    width: height * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height * 0.015),
                      image: const DecorationImage(
                        image: AssetImage("assets/frontlogo.jpeg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: width * 0.07,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: height / 6,
              ),
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: width,
                  height: height,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: height / 2.34,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: width > 600 ? 3 : 2,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 25,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: imagData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onTapAction[index](context);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  imagData[index],
                                  width: 100,
                                ),
                                Text(
                                  Titles[index],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height / 5, left: width / 13),
              child: Container(
                width: width / 1.2,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  child: CarouselSlider(
                    items: [
                      SizedBox(
                        width: double.infinity,
                        child: Image.asset('assets/slider1.jpg',
                            fit: BoxFit.cover),
                      ),
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: Image.asset('assets/slider2.jpg',
                      //       fit: BoxFit.cover),
                      // ),
                      SizedBox(
                        width: double.infinity,
                        child: Image.asset('assets/onboard3.jpg',
                            fit: BoxFit.cover),
                      ),
                    ],
                    options: CarouselOptions(
                      height: height - 620,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayInterval: const Duration(seconds: 3),
                      enableInfiniteScroll: true,
                      viewportFraction: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
