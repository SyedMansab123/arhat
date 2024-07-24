// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, unused_import

import 'package:arhat/common/widgets/customized_button.dart';
import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
import 'package:arhat/data/services/firebase_arhat_expense_service.dart';
import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/models/arhat_expense_model.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Reports/customer_view_report.dart';
import 'package:arhat/screens/Dashboard/Reports/merchant_report.dart';
import 'package:arhat/screens/Dashboard/Reports/expense_report.dart';
import 'package:arhat/screens/Dashboard/dashboard.dart';
import 'package:arhat/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewsReports extends StatefulWidget {
  const ViewsReports({super.key});

  @override
  State<ViewsReports> createState() => _ViewsReportsState();
}

class _ViewsReportsState extends State<ViewsReports> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loadingExpense = false;
  bool loadingMerchant = false;
  bool loadingCustomer = false;
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
                        Navigator.push(context, MaterialPageRoute(builder:(context)=>const Dashboard()));
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
                    "Reports",
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
                          buttonTexts: "Customer Reports",
                          buttonColor: const Color.fromARGB(255, 3, 59, 20),
                          textColor: Colors.white,
                          loading: loadingCustomer,
                          onPressed: () async {
                            //   String? currentUserId=_auth.currentUser!.uid;
                            //    List<CustomCutomerModel> savedDataCustomer = await FirebaseCustomerService().getSavedData('ArhatCustomer',currentUserId);

                            // // Navigate to the next screen and pass the saved data
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => CustomerReportScreen(savedDataCustomer)),
                            // );
                            setState(() {
                              loadingCustomer=true;
                            });
                            try {
                              String? currentUserId = _auth.currentUser!.uid;
                              List<CustomMerchantModel> savedDataMerchant =
                                  await FirebaseMerchantService().getSavedData(
                                      'ArhatMerchant', currentUserId);

                              // Navigate to the next screen and pass the saved data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerViewReport(savedDataMerchant)),
                              );
                               setState(() {
                              loadingCustomer=false;
                            });
                            } catch (e) {
                              // Handle exceptions
                              Utils().toastMessage(
                                  'Error: $e'); // Display error message
                            }
                             setState(() {
                              loadingCustomer=false;
                            });
                          }),
                      CustomizedButton(
                          buttonTexts: "Expense Report",
                          buttonColor: Colors.white,
                          textColor: const Color.fromARGB(255, 3, 59, 20),
                          loading: loadingExpense,
                          onPressed: () async {
                            setState(() {
                              loadingExpense = true;
                            });
                            try {
                              String? currentUserId = _auth.currentUser!.uid;
                              List<CustomExpenseModel> savedData =
                                  await FirebaseExpenseService().getSavedData(
                                      'ArhatExpense', currentUserId);

                              // Navigate to the next screen and pass the saved data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ExpenseReportScreen(savedData)),
                              );
                              loadingExpense = false;
                            } catch (e) {
                              setState(() {
                                loadingExpense = false;
                              });
                              // Handle exceptions
                              Utils().toastMessage(
                                  'Error: $e'); // Display error message
                            }
                          }),
                      CustomizedButton(
                          buttonTexts: "Merchant Reports",
                          buttonColor: const Color.fromARGB(255, 3, 59, 20),
                          textColor: Colors.white,
                          loading: loadingMerchant,
                          onPressed: () async {
                            setState(() {
                              loadingMerchant = true;
                            });
                            try {
                              String? currentUserId = _auth.currentUser!.uid;
                              List<CustomMerchantModel> savedDataMerchant =
                                  await FirebaseMerchantService().getSavedData(
                                      'ArhatMerchant', currentUserId);

                              // Navigate to the next screen and pass the saved data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MerchantReportScreen(
                                        savedDataMerchant)),
                              );
                              setState(() {
                                loadingMerchant = false;
                              });
                            } catch (e) {
                              // Handle exceptions
                              Utils().toastMessage('Error: $e');
                              setState(() {
                                loadingMerchant = false;
                              }); // Display error message
                            }
                          })
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
