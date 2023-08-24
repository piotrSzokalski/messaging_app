import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/chat.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getChats() {
    return _firestore
        .collection("chats")
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  getMessages(String id) {
    var x = _firestore
        .collection("chats")
        .doc(id)
        .collection("messages")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()['text']).toList());
    return x;
  }
}
