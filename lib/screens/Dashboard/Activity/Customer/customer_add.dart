// ignore_for_file: unnecessary_import, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, use_build_context_synchronously

import "package:arhat/common/widgets/customized_textfield.dart";
import "package:arhat/controllers/customer_controller.dart";
import "package:arhat/data/services/firebase_arhat_customer_service.dart";
import "package:arhat/models/arhat_customer_model.dart";
import "package:arhat/screens/Dashboard/Activity/Customer/customer_displayscreen.dart";
import "package:arhat/utils/utils.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:intl/intl.dart";

class CustomerAdd extends StatefulWidget {
  final String merchantId;
  final double merchantProductQuantity;
  final String merchantProductName;
  final String merchantProductQuantityType;
  final double merchantCostPerWeight;
  final double merchantTotalweight;
  final double sellingProfit;
  const CustomerAdd(
      {Key? key,
      required this.merchantId,
      required this.merchantProductQuantity,
      required this.merchantProductName,
      required this.merchantProductQuantityType,
      required this.merchantCostPerWeight,
      required this.merchantTotalweight,
      required this.sellingProfit});

  @override
  State<CustomerAdd> createState() => _CustomerAddState();
}

class _CustomerAddState extends State<CustomerAdd> {
  late final ArhatCustomerController _controllerCustomer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _controllerCustomer = ArhatCustomerController();
  }

  @override
  void dispose() {
    _controllerCustomer.dispose();
    super.dispose();
  }

  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _controllerCustomer.productName =
        TextEditingController(text: widget.merchantProductName);
    _controllerCustomer.productQuatityType =
        TextEditingController(text: widget.merchantProductQuantityType);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 59, 20),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
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
                          Navigator.pop(context);
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
                  child: Text(
                    "Customer",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(195, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),

                  // height: height,
                  width: width,
                  height: height - 338,
                  // padding: const EdgeInsets.only(bottom: 10, top: 50),
                  // child:
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Container(
                width: width - 50,
                height: height - 250,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      CustomizedTextfield(
                        myController: _controllerCustomer.customerName,
                        hintText: "Enter Customer Name",
                        isPassword: false,
                      ),
                      CustomizedTextfield(
                        myController: _controllerCustomer.customerAddress,
                        hintText: "Enter Customer Current Address",
                        isPassword: false,
                      ),
                      CustomizedTextfield(
                        myController: _controllerCustomer.customerContact,
                        hintText: "  Enter Contact Number",
                        isPassword: false,
                        prefix: "+92",
                        onChanged: (value) {
                          if (value.length <= 10) {
                            // Process the value as needed
                            // For example, you could update a state or call another function
                          } else {
                            // If the input is greater than 11, truncate it
                            _controllerCustomer.customerContact.text =
                                value.substring(0, 10);
                            // Move the cursor to the end of the truncated text
                            _controllerCustomer.customerContact.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _controllerCustomer
                                      .customerContact.text.length),
                            );
                          }
                        },
                      ),
                      CustomizedTextfield(
                        myController: _controllerCustomer.productName,
                        // hintText: "Enter Product Name",
                        isPassword: false,
                        readonly: true,
                      ),
                      CustomizedTextfield(
                        myController: _controllerCustomer.productQuatity,
                        hintText: "Enter Product Quantity",
                        isPassword: false,
                      ),
                      CustomizedTextfield(
                        myController: _controllerCustomer.advancePayment,
                        hintText: "Enter Advance Payment",
                        isPassword: false,
                      ),
                      CustomizedTextfield(
                        myController: _controllerCustomer.productQuatityType,
                        // hintText: "Enter Product Quantity Type",
                        isPassword: false,
                        readonly: true,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              // Create a CustomModel object from user input
              CustomCutomerModel model = CustomCutomerModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  customerAdress: _controllerCustomer.customerAddress.text,
                  customerName: _controllerCustomer.customerName.text,
                  productName: _controllerCustomer.productName.text,
                  quantityType: _controllerCustomer.productQuatityType.text,
                  merchantCustomerId: double.parse(widget.merchantId),
                  datetimeString: DateFormat().format(DateTime.now()),
                  customerNumber:
                      double.parse(_controllerCustomer.customerContact.text),
                  productQuantity:
                      double.parse(_controllerCustomer.productQuatity.text),
                  advancePayment:
                      double.parse(_controllerCustomer.advancePayment.text),
                  remainingAmount: (((widget.merchantTotalweight /
                                  widget.merchantProductQuantity) *
                              double.parse(
                                  _controllerCustomer.productQuatity.text)) *
                          (widget.merchantCostPerWeight +
                              (widget.merchantCostPerWeight * (5 / 100)))) -
                      double.parse(_controllerCustomer.advancePayment.text),
                  totalWeight:
                      (widget.merchantTotalweight / widget.merchantProductQuantity) *
                          double.parse(_controllerCustomer.productQuatity.text),
                  totalAmount: ((widget.merchantTotalweight / widget.merchantProductQuantity) *
                          double.parse(_controllerCustomer.productQuatity.text)) *
                      (widget.merchantCostPerWeight + (widget.merchantCostPerWeight * (5 / 100))));

              String? currentUserId = _auth.currentUser!.uid;

              // Get the sum of product quantities of existing customers
              List<CustomCutomerModel> savedDataCustomer =
                  await FirebaseCustomerService().getSavedData(
                      'ArhatCustomer', currentUserId, widget.merchantId);
              double sumProductQuantity = 0;
              for (var customer in savedDataCustomer) {
                sumProductQuantity += customer.productQuantity;
              }

              if (sumProductQuantity +
                      double.parse(_controllerCustomer.productQuatity.text) ==
                  widget.merchantProductQuantity) {
                await _firestore
                    .collection("users")
                    .doc(currentUserId)
                    .collection("ArhatMerchant")
                    .doc(widget.merchantId)
                    .update({
                  'paymentStatus': true,
                });
              }

              double remainingProduct =
                  sumProductQuantity - widget.merchantProductQuantity;

              double totalAmount = ((widget.merchantTotalweight /
                          widget.merchantProductQuantity) *
                      double.parse(_controllerCustomer.productQuatity.text)) *
                  (widget.merchantCostPerWeight +
                      (widget.merchantCostPerWeight *
                          (widget.sellingProfit / 100)));
              // Check if adding the new customer exceeds the merchant's product quantity

              if (double.parse(_controllerCustomer.advancePayment.text) <=
                  totalAmount) {
                if (sumProductQuantity +
                        double.parse(_controllerCustomer.productQuatity.text) <=
                    widget.merchantProductQuantity) {
                  // Save data to Firestore
                  await FirebaseCustomerService().setData(
                      'ArhatCustomer', model, currentUserId, widget.merchantId);

                  // Clear text fields after saving data
                  _controllerCustomer.customerAddress.clear();
                  _controllerCustomer.customerContact.clear();
                  _controllerCustomer.customerName.clear();
                  _controllerCustomer.productName.clear();
                  _controllerCustomer.productQuatity.clear();
                  _controllerCustomer.productQuatityType.clear();

                  List<CustomCutomerModel> savedCurrentDataCustomer =
                      await FirebaseCustomerService().getSavedData(
                          'ArhatCustomer', currentUserId, widget.merchantId);

                  // Navigate to the next screen and pass the saved data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerDisplayScreen(
                        savedCurrentDataCustomer,
                        merchantId: widget.merchantId,
                        merchantProductQuantity: widget.merchantProductQuantity,
                        merchantProductQuantityType:
                            widget.merchantProductQuantityType,
                        merchantProductName: widget.merchantProductName,
                        merchantCostPerWeight: widget.merchantCostPerWeight,
                        merchantTotalweight: widget.merchantTotalweight,
                        sellingProfit: widget.sellingProfit,
                      ),
                    ),
                  );
                } else {
                  // Display a message that all products are sold
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Product Sold Out"),
                        content: Text(
                            "All products have been sold. Cannot add a new customer.Remaining product is $remainingProduct"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(" Advance Payment is Exceed "),
                      content: Text(
                          "Your Advance Payment is Exceed the Total Amount! $totalAmount"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              }
            } catch (e) {
              // Handle error
              Utils().toastMessage(e.toString());
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content:
                        const Text("Failed to save data. Please try again."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        tooltip: 'Increment',
        backgroundColor: const Color.fromARGB(255, 3, 59, 20),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
