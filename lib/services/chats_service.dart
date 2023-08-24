import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/chat.dart';
import 'package:messaging_app/models/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<String>> getChats() {
    return _firestore
        .collection("chats")
        .limit(100)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<List<Message>> getMessages(String id) {
    var x = _firestore
        .collection("chats")
        .doc(id)
        .collection("messages")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              print("________________");
              // print(doc.id);
              // print(doc.data()['text']);
              // print(doc.data()['author']);
              // print(doc.data()['timestamp']);
              var x = Message(
                  id: doc.id,
                  timestamp: doc.data()['timestamp'],
                  author: doc.data()['author'],
                  text: doc.data()['text']);
              print(x.toString());
              return x;
            }).toList());
    return x;
  }
}
