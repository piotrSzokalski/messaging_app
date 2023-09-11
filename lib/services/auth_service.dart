import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:messaging_app/pages/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //bool get isAuthenticated => _user != null;

  Future<UserCredential> singInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      throw exception;
    }
  }

  Future<UserCredential> singInWithUsernameAndPassword(
      String username, String password) async {
    String email = "";
    try {
      var snapshot = await _firestore
          .collection("users")
          .where("username", isEqualTo: username)
          .limit(1)
          .get();
      email = snapshot.docs[0]["email"];
    } catch (e) {
      throw Exception("No such user");
    }
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      throw exception;
    }
  }

  Future<UserCredential> register(
      String username, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _firestore.collection("users").doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (exception) {
      throw exception;
    }
  }

  Future<void> resetPassword(String email) {
    try {
      return _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (exception) {
      throw exception.code;
    }
  }
}
