import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/chat.dart';
import 'package:messaging_app/models/message.dart';
import 'package:crypt/crypt.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<List<String>> getChats() {
    return _firestore
        .collection("chats")
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<List<Message>> getMessages(String id) {
    return _firestore
        .collection("chats")
        .doc(id)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var x = Message(
                  id: doc.id,
                  timestamp: doc.data()['timestamp'],
                  author: doc.data()['author'],
                  text: doc.data()['text']);
              return x;
            }).toList());
  }

  void sendMessage(
      {String? chatId, required String author, required String text}) {
    if (chatId == null) {
      return;
    }
    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add({'author': author, 'text': text, 'timestamp': Timestamp.now()});
  }

  Future<bool> nameAvailable(String id) {
    if (id.isEmpty) {
      return Future.value(true);
    }

    return _firestore
        .collection("chats")
        .doc(id)
        .get()
        .then((doc) => !doc.exists);
  }

  String _generateRandomString(int length) {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final String generatedString = String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
    return generatedString;
  }

  Future<bool> createChannel({required String id, String? password}) async {
    if (id.isEmpty) {
      return Future.value(false);
    }
    bool available = await nameAvailable(id);
    if (!available) {
      return false;
    }

    if (password == null || password!.isEmpty) {
      await _firestore
          .collection("chats")
          .doc(id)
          .set({'owner': _firebaseAuth.currentUser?.email});
      return true;
    }

    String salt = _generateRandomString(12);
    String saltedPasswordHash = Crypt.sha256(password, salt: salt).toString();

    await _firestore.collection("chats").doc(id).set({
      'owner': _firebaseAuth.currentUser?.email,
      'passwordSecured': true,
      'password': saltedPasswordHash,
      'salt': salt
    });
    return true;
  }

  Future<bool> isProtected(String id) async {
    var snapshot = await _firestore.collection("chats").doc(id).get();
    var data = snapshot.data();
    return data!.containsKey("passwordSecured") ? true : false;
  }

  Future<String> unlock(String chatId, String password) async {
    var snapshot = await _firestore.collection("chats").doc(chatId).get();
    var data = snapshot.data();
    String salt = data!['salt'];
    String storedPassword = data['password'];

    String saltedPasswordHash = Crypt.sha256(password, salt: salt).toString();

    if (saltedPasswordHash == storedPassword) {
      return "Password Correct";
    }
    return "INCORECT";
  }
}
