import 'package:flutter/material.dart';

class ArhatMerchantController {
  final TextEditingController storeNo = TextEditingController();
  final TextEditingController storeRent = TextEditingController();
  final TextEditingController roomNo = TextEditingController();
  final TextEditingController truckid = TextEditingController();
  final TextEditingController truckQuantity = TextEditingController();
  final TextEditingController truckRent = TextEditingController();
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController merchantAddress = TextEditingController();
  final TextEditingController merchantContact = TextEditingController();
  final TextEditingController productName = TextEditingController();
  final TextEditingController productQuantity = TextEditingController();
  final TextEditingController productQuantityType = TextEditingController();
  final TextEditingController totalWeight = TextEditingController();
  final TextEditingController costPerWeight = TextEditingController();
  final TextEditingController commission = TextEditingController();
  final TextEditingController mazduri = TextEditingController();
  final TextEditingController sellingProfit = TextEditingController();

  void dispose() {
    storeNo.dispose();
    storeRent.dispose();
    roomNo.dispose();
    truckid.dispose();
    truckQuantity.dispose();
    truckRent.dispose();
    merchantName.dispose();
    merchantAddress.dispose();
    merchantContact.dispose();
    productName.dispose();
    productQuantity.dispose();
    productQuantityType.dispose();
    totalWeight.dispose();
    costPerWeight.dispose();
    commission.dispose();
    mazduri.dispose();
    sellingProfit.dispose();
  }
}
