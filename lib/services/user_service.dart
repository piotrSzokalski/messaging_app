import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<String> getUserName() {
    String? uid = _firebaseAuth.currentUser?.uid;
    //print("UID");
    //print(uid);
    return _firestore
        .collection("users")
        .doc(uid)
        .snapshots()
        .map((snapshot) => snapshot.data()?["username"] as String);
  }

  Future<String> getUserEmail(String username) async {
    try {
      var snapshot = await _firestore
          .collection("user")
          .where("username", isEqualTo: username)
          .limit(1)
          .get();
      return snapshot.docs[0]['email'];
    } catch (e) {
      throw Exception("No such user");
    }
  }
}
