import 'package:flutter/material.dart';

class ArhatCustomerController {
 final TextEditingController customerName = TextEditingController();
  final TextEditingController customerAddress = TextEditingController();
  final TextEditingController customerContact = TextEditingController();
   TextEditingController productName = TextEditingController();
  final TextEditingController productQuatity = TextEditingController();
   TextEditingController productQuatityType = TextEditingController();
   TextEditingController advancePayment = TextEditingController();
  void dispose() {
    customerName.dispose();
    customerAddress.dispose();
    customerContact.dispose();
    productName.dispose();
    productQuatity.dispose();
    productQuatityType.dispose();
    advancePayment.dispose();
  }
}
