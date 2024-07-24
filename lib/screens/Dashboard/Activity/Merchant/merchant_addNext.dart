// ignore_for_file: prefer_typing_uninitialized_variables, file_names, use_build_context_synchronously, unused_import, override_on_non_overriding_member

import 'package:arhat/common/widgets/customized_textfield.dart';
import 'package:arhat/controllers/merchant_controller.dart';
import 'package:arhat/data/services/firebase_arhat_Merchant_service.dart';
import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/screens/Dashboard/Activity/Merchant/merchant_displayscreen.dart';
import 'package:arhat/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MerchantAddNext extends StatefulWidget {
   final ArhatMerchantController controllerMerchantNext;
  const MerchantAddNext({super.key, required this.controllerMerchantNext});

  @override
  State<MerchantAddNext> createState() => _PurchaseAddState();
}

class _PurchaseAddState extends State<MerchantAddNext> {
 
 final FirebaseAuth _auth=FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

 @override
  // void initState() {
  //   super.initState();
  //   controllerMerchantNext = ArhatMerchantController();
  // }

  // @override
  // void dispose() {
  //   _controllerMerchantNext.dispose();
  //   super.dispose();
  // }

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
                      myController: widget.controllerMerchantNext.sellingProfit,
                      hintText: "Enter Profit Percentage for Selling",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.storeNo,
                      hintText: "Enter Store Number",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.roomNo,
                      hintText: "Enter Room Number",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.storeRent,
                      hintText: "Enter Store Rent Amount",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.mazduri,
                      hintText: "Enter Mazduri",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.truckid,
                      hintText: "Enter Truck Id",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.commission,
                      hintText: "Enter Commision In %",
                      isPassword: false,
                    ),
                    CustomizedTextfield(
                      myController: widget.controllerMerchantNext.truckQuantity,
                      hintText: "Enter Truck Quantity",
                      isPassword: false,
                    ),
                      CustomizedTextfield(
                      myController: widget.controllerMerchantNext.truckRent,
                      hintText: "Enter Truck Rent Amount",
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
        onPressed: ()  async {
           if (_formKey.currentState!.validate()){
  try {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    final commissionCalculate= (double.parse(widget.controllerMerchantNext.costPerWeight.text)/40);
    final sellingProfit= double.parse(widget.controllerMerchantNext.sellingProfit.text);
    // Create a CustomMerchantModel object from user input
    CustomMerchantModel model = CustomMerchantModel(
      id: id,
      storeNo: widget.controllerMerchantNext.storeNo.text,
      roomNo: widget.controllerMerchantNext.roomNo.text,
      storeRent: double.parse(widget.controllerMerchantNext.storeRent.text),
      truckId: widget.controllerMerchantNext.truckid.text,
      truckRent: double.parse(widget.controllerMerchantNext.truckRent.text),
      truckQuantity: double.parse(widget.controllerMerchantNext.truckQuantity.text),
      commission:double.parse(widget.controllerMerchantNext.commission.text), 
      totalWeight: double.parse(widget.controllerMerchantNext.totalWeight.text),
      costPerWeight: double.parse(widget.controllerMerchantNext.costPerWeight.text),
      merchantName: widget.controllerMerchantNext.merchantName.text,
       merchantAddress: widget.controllerMerchantNext.merchantAddress.text,
       merchantContact:double.parse(widget.controllerMerchantNext.merchantContact.text),
      productName: widget.controllerMerchantNext.productName.text,
      productQuantity: double.parse(widget.controllerMerchantNext.productQuantity.text),
       productQuantityType: widget.controllerMerchantNext.productQuantityType.text,
       productId: id,
       datetime: DateFormat().format(DateTime.now()),
       paymentStatus: false,
       sellingProfit: sellingProfit,
       mazduri: double.parse(widget.controllerMerchantNext.mazduri.text),
       commissionAmount: ((((commissionCalculate*sellingProfit/100)+commissionCalculate)*double.parse(widget.controllerMerchantNext.totalWeight.text)))*double.parse(widget.controllerMerchantNext.commission.text)/100,
     totalSale: ((((commissionCalculate*sellingProfit/100)+commissionCalculate)*double.parse(widget.controllerMerchantNext.totalWeight.text)))
     
    );

    String? currentUserId = _auth.currentUser!.uid;

    // Save data to Firestore
    await FirebaseMerchantService().setData('ArhatMerchant', model, currentUserId);

  //  _controller.merchantAddress.clear();
  //  _controller.merchantContact.clear();
  //  _controller.merchantName.clear();
  //  _controller.productName.clear();
  //  _controller.productQuantity.clear();
  //  _controller.productQuantityType.clear();

     List<CustomMerchantModel> savedDataMerchant = await FirebaseMerchantService().getSavedData('ArhatMerchant', currentUserId);

    // Navigate to the next screen and pass the saved data
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MerchantDisplayScreen(savedDataMerchant)),
    );
  } catch (e) {
    // Handle error
    Utils().toastMessage(e.toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Failed to save data. Please try again."),
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
  }}
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
