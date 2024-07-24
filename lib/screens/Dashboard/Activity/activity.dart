// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, unused_import

import 'package:arhat/common/widgets/customized_button.dart';
import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Activity/Customer/customer_displayscreen.dart';
import 'package:arhat/screens/Dashboard/Activity/Merchant/merchant_displayscreen.dart';
import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ActivityButton extends StatefulWidget {
  const ActivityButton({super.key});

  @override
  State<ActivityButton> createState() => _ActivityButtonState();
}

class _ActivityButtonState extends State<ActivityButton> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 59, 20),
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.center, children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 35,
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Dashboard(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Activity",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),

                // height: height,
                width: width,
                height: height - 290,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      CustomizedButton(
                          buttonTexts: "Merchant",
                          buttonColor: const Color.fromARGB(255, 3, 59, 20),
                          textColor: Colors.white,
                          onPressed: () async {
                            // String? currentUserId = _auth.currentUser!.uid;
                            // List<CustomMerchantModel> merchantData =
                            //     await FirebaseMerchantService().getSavedData(
                            //         'ArhatMerchant', currentUserId);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (Context) =>
                            //             MerchantDisplayScreen(merchantData)));
                          }),
                      // CustomizedButton(
                      //     buttonTexts: "Customer",
                      //     buttonColor: Colors.white,
                      //     textColor: const Color.fromARGB(255, 3, 59, 20),
                      //     onPressed: () async {
                      //       // String? currentUserId = _auth.currentUser!.uid;
                      //       // List<CustomCutomerModel> DataCustomer =
                      //       //     await FirebaseCustomerService().getSavedData(
                      //       //         'ArhatCustomer', currentUserId);

                      //       // // Navigate to the next screen and pass the saved data
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute(
                      //       //       builder: (context) =>
                      //       //           CustomerDisplayScreen(DataCustomer)),
                      //       // );
                      //       // print("Tapped 3");
                      //     })
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
