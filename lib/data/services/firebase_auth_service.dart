// ignore_for_file: non_constant_identifier_names

import 'package:arhat/models/User_model.dart';
import 'package:arhat/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CustomUserModel?> signUp(
      String email, String password, String username) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      CustomUserModel user = CustomUserModel(
        id: userCredential.user!.uid,
        userName: username,
        email: email,
      );

      await _firestore.collection('users').doc(user.id).set({
        'userid': user.id,
        'username': user.userName,
        'email': user.email,
      });

      return user;
    } catch (e) {
      // print('Sign up failed: $e');
      Utils().toastMessage(e.toString());
      return null;
    }
  }

  Future<CustomUserModel?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userSnapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return CustomUserModel(
        id: userCredential.user!.uid,
        userName: userSnapshot['username'],
        email: userSnapshot['email'],
      );
    } catch (e) {
      // print('Sign in failed: $e');
      Utils().toastMessage(e.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> DeleteAccount(String collection, String curretUserid) async {
    try {
      await _firestore.collection(collection).doc(curretUserid).delete();
      await _auth.currentUser?.delete();
    } catch (e) {
      // print("Error setting data: $e");
      Utils().toastMessage(e.toString());
    }
  }
}

// class FirebaseAuthService {
//   FirebaseAuth auth = FirebaseAuth.instance;

//   Future login(String email, String password) async {
//     await auth.signInWithEmailAndPassword(email: email, password: password);
//   }

//   Future signup(String email, String password) async {
//     await auth.createUserWithEmailAndPassword(email: email, password: password);
//   }

//    Future logininwithgoogle() async {
//     GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//     AuthCredential myCredential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//     UserCredential user =
//         await FirebaseAuth.instance.signInWithCredential(myCredential);

//     debugPrint(user.user?.displayName);
//   }
// }
