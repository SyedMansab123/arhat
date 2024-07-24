// // ignore_for_file: library_private_types_in_public_api

// import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
// import 'package:arhat/models/arhat_customer_model.dart';
// import 'package:arhat/models/arhat_merchant_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// ignore_for_file: library_private_types_in_public_api

import 'package:arhat/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arhat/data/services/firebase_arhat_customer_service.dart';
import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/models/arhat_merchant_model.dart';

class CustomerGurahi extends StatefulWidget {
  final List<CustomMerchantModel>? savedDataMerchant;

  const CustomerGurahi(this.savedDataMerchant, {super.key});

  @override
  _CustomerGurahiState createState() => _CustomerGurahiState();
}

class _CustomerGurahiState extends State<CustomerGurahi> {
  late List<CustomCutomerModel>? _filteredDataCustomer = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _amountController;
  final double remaining = 0.0;
  // late CustomCutomerModel _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomerData() async {
    if (widget.savedDataMerchant != null) {
      List<CustomCutomerModel> customers = [];
      String? currentUserId = _auth.currentUser!.uid;

      for (CustomMerchantModel merchant in widget.savedDataMerchant!) {
        String merchantId = merchant.productId.toString();
        List<CustomCutomerModel> merchantCustomers =
            await FirebaseCustomerService()
                .getSavedData('ArhatCustomer', currentUserId, merchantId);
        customers.addAll(merchantCustomers);
      }

      setState(() {
        _filteredDataCustomer = customers;
      });
    }
  }

  Future<void> _updateAdvancePayment(double enteredAmount, double totalAmount,
      double advancePayment, int merchantCustomerId, String customerid) async {
    // double totalAmount = _selectedCustomer.totalAmount ?? 0;
    // double currentAdvancePayment = _selectedCustomer.advancePayment ?? 0;

    if (enteredAmount + advancePayment <= totalAmount) {
      // Update advance payment in Firestore
      String currentUserId = _auth.currentUser!.uid;
      await _firestore
          .collection("users")
          .doc(currentUserId)
          .collection("ArhatMerchant")
          .doc("$merchantCustomerId")
          .collection("ArhatCustomer")
          .doc(customerid) // Use the selected merchant ID
          .update({'advancePayment': enteredAmount + advancePayment}).then(
              (value) async {
        await _firestore
            .collection("users")
            .doc(currentUserId)
            .collection("ArhatMerchant")
            .doc("$merchantCustomerId")
            .collection("ArhatCustomer")
            .doc(customerid) // Use the selected merchant ID
            .update({
          'remainingAmount': totalAmount - (enteredAmount + advancePayment)
        });
      });
      Utils().toastMessage("Successfully updated");
      // Refresh customer data after update
      _fetchCustomerData();
    } else {
      // Show AlertDialog indicating all payments have been paid
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('All payments have been paid'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showPaymentDialog(
      CustomCutomerModel customer,
      double totalAmount,
      double advancePayment,
      double remainingAmount,
      int merchantCustomerId,
      String customerid) {
    // _selectedCustomer = customer;
    // Set the selected merchant ID
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter payment amount'),
          content: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText:
                  "Remaining Aomunt is : ${remainingAmount.toStringAsFixed(1)}",
              helperText:
                  "Your remaining Amount is : ${remainingAmount.toStringAsFixed(1)}",
              labelText: 'Amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double enteredAmount =
                    double.tryParse(_amountController.text) ?? 0;
                _updateAdvancePayment(enteredAmount, totalAmount,
                    advancePayment, merchantCustomerId, customerid);

                setState(() {
                  remainingAmount = enteredAmount + advancePayment;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          toolbarHeight: 75,
          backgroundColor: const Color.fromARGB(255, 3, 59, 20),
          title: const Text(
            "Customer Data",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: _filteredDataCustomer != null
                          ? ListView.builder(
                              itemCount: _filteredDataCustomer!.length,
                              itemBuilder: (context, index) {
                                CustomCutomerModel model =
                                    _filteredDataCustomer![index];
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Customer Name: ${model.customerName.toUpperCase()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 3, 59, 20),
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Customer Adress:  ${model.customerAdress.toUpperCase()}',
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Contact No:  +92${model.customerNumber.toStringAsFixed(0)}',
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Product Name:  ${model.productName.toUpperCase()}',
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Product Quantity:  ${model.productQuantity.toStringAsFixed(0)}',
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        'Quatity Type:  ${model.quantityType.toUpperCase()}',
                                      ),
                                      // Other details...
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 3, 59, 20),
                                            ),
                                            onPressed: () async {
                                              if (model.remainingAmount ==
                                                  0.0) {
                                                Utils().toastMessage(
                                                    "All Payment Have Been Paid");
                                              } else {
                                                _showPaymentDialog(
                                                    model,
                                                    model.totalAmount,
                                                    model.advancePayment,
                                                    model.remainingAmount,
                                                    model.merchantCustomerId
                                                        .toInt(),
                                                    model
                                                        .id); // Pass the merchant ID
                                              }
                                            },
                                            child: const Text('Update payment',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('Empty Customer',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 3, 59, 20),
                                  )),
                            ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
