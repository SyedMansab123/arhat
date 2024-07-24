// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_import, use_build_context_synchronously, unused_import

import "package:arhat/common/widgets/customized_textfield.dart";
import "package:arhat/controllers/merchant_controller.dart";
import "package:arhat/data/services/firebase_arhat_Merchant_service.dart";
import "package:arhat/models/arhat_merchant_model.dart";
import "package:arhat/screens/Dashboard/Activity/Merchant/merchant_addNext.dart";
import "package:arhat/utils/utils.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";

class MerchantAdd extends StatefulWidget {
  const MerchantAdd({super.key});

  @override
  State<MerchantAdd> createState() => _MerchantAddState();
}

class _MerchantAddState extends State<MerchantAdd> {
  late final ArhatMerchantController _controllerMerchant;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // final FirebaseAuth _auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controllerMerchant = ArhatMerchantController();
  }

  @override
  void dispose() {
    _controllerMerchant.dispose();
    super.dispose();
  }

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
                  "Merchant",
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
                      myController: _controllerMerchant.merchantName,
                      hintText: "Enter Merchant Name",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.merchantAddress,
                      hintText: "Enter Current Address",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.merchantContact,
                      hintText: "   Enter Contact Number",
                      isPassword: false,
                      prefix: "+92",
                      onChanged: (value) {
                        if (value.length <= 10) {
                          // Process the value as needed
                          // For example, you could update a state or call another function
                        } else {
                          // If the input is greater than 11, truncate it
                          _controllerMerchant.merchantContact.text =
                              value.substring(0, 10);
                          // Move the cursor to the end of the truncated text
                          _controllerMerchant.merchantContact.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: _controllerMerchant
                                    .merchantContact.text.length),
                          );
                        }
                      },
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.productName,
                      hintText: "Enter Product Name",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.productQuantity,
                      hintText: "Enter Product Quantity",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.productQuantityType,
                      hintText: "Enter Product Quatity Type",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.totalWeight,
                      hintText: "Enter Total Weight",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: _controllerMerchant.costPerWeight,
                      hintText: "Enter Cost of 40kg Weight",
                      isPassword: false,
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MerchantAddNext(
                          controllerMerchantNext: _controllerMerchant,
                        )),
              );
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
          Icons.navigate_next,
          color: Colors.white,
        ),
      ),
    );
  }
}
