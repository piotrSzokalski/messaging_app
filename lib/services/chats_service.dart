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
    return _firestore
        .collection("chats")
        .doc(id)
        .get()
        .then((doc) => !doc.exists);
  }

  Future<bool> createChannel(String id) async {
    bool available = await nameAvailable(id);
    if (!available) {
      return false;
    }
    await _firestore.collection("chats").doc(id).set({});
    return true;
  }
}
