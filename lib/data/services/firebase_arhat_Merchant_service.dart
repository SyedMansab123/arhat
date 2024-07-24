// ignore_for_file: file_names

import 'package:arhat/models/arhat_merchant_model.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMerchantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setData(String collection, CustomMerchantModel model,
      String currentUserid) async {
    try {
      await _firestore
          .collection("users")
          .doc(currentUserid)
          .collection(collection)
          .doc(model.id)
          .set(model.toMap());
    } catch (e) {
      Utils().toastMessage(e.toString());
    }
  }

  Future<List<CustomMerchantModel>> getSavedData(
      String collection, String currentUserid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .doc(currentUserid)
          .collection(collection)
          .get();
      return querySnapshot.docs
          .map((doc) => CustomMerchantModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      Utils().toastMessage(e.toString());
      rethrow;
    }
  }
}
