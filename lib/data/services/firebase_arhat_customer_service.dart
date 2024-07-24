import 'package:arhat/models/arhat_customer_model.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setData(String collection, CustomCutomerModel model,
      String curretUserid, String merchantId) async {
    try {
      await _firestore
          .collection("users")
          .doc(curretUserid)
          .collection("ArhatMerchant")
          .doc(merchantId)
          .collection(collection)
          .doc(model.id)
          .set(model.toMap());
    } catch (e) {
      // print("Error setting data: $e");
      Utils().toastMessage(e.toString());
    }
  }

  Future<List<CustomCutomerModel>> getSavedData(
      String collection, String curretUserid, String merchantId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .doc(curretUserid)
          .collection("ArhatMerchant")
          .doc(merchantId)
          .collection(collection)
          .get();
      return querySnapshot.docs
          .map((doc) => CustomCutomerModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // print("Error fetching data: $e");
      Utils().toastMessage(e.toString());
      rethrow;
    }
  }
}
