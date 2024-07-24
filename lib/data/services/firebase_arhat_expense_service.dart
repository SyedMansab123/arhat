import 'package:arhat/models/arhat_expense_model.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setData(
      String collection, CustomExpenseModel model, String curretUserid) async {
    try {
      await _firestore
          .collection("users")
          .doc(curretUserid)
          .collection(collection)
          .doc(model.id)
          .set(model.toMap());
    } catch (e) {
      // print("Error setting data: $e");
      Utils().toastMessage(e.toString());
    }
  }

  Future<List<CustomExpenseModel>> getSavedData(
      String collection, String curretUserid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .doc(curretUserid)
          .collection(collection)
          .get();
      return querySnapshot.docs
          .map((doc) => CustomExpenseModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // print("Error fetching data: $e");
      Utils().toastMessage(e.toString());
      rethrow;
    }
  }
}
