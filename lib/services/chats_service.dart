import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:messaging_app/models/message.dart';
import 'package:crypt/crypt.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<List<Map<String, dynamic>>> getChats(String query) {
    return _firestore.collection("chats").snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) {
          final bool isPasswordProtected =
              doc.data().containsKey('passwordSecured');
          return {
            'id': doc.id,
            'locked': isPasswordProtected,
            'owner': doc.data()['owner']
          };
        })
        .where((map) =>
            (map['id'] as String).toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

  Stream<List<Message>>? getMessages(String id) {
    return _firestore
        .collection("chats")
        .doc(id)
        .collection("messages")
        .orderBy("timestamp")
        .snapshots()
        .map((snapshot) {
      {
        return snapshot.docs.map((doc) {
          return Message(
              id: doc.id,
              timestamp: doc.data()['timestamp'],
              author: doc.data()['author'],
              text: doc.data()['text'],
              images: List<String>.from(doc.data()['images'] as List));
        }).toList();
      }
    });
  }

  Future<void> sendMessage(
      {String? chatId,
      required String author,
      required String text,
      List<XFile>? images}) async {
    if (chatId == null) {
      return;
    }

    List<String> imageUrls = [];

    if (images != null && images.isNotEmpty) {
      var rootDir = _storage.ref();
      var imagesDir = rootDir.child("images");
      for (XFile image in images) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference imageReference = imagesDir.child(fileName);
        try {
          await imageReference.putFile(File(image.path));
          var url = await imageReference.getDownloadURL();
          imageUrls.add(url);
        } catch (error) {
          print("____________________");
          print(error);
        }
      }
    }

    Map<String, dynamic> dataToSend = {
      'author': author,
      'text': text,
      'timestamp': Timestamp.now()
    };

    if (imageUrls.isNotEmpty) {
      dataToSend['images'] = imageUrls;
    } else {
      dataToSend['images'] = (List<String>.from([]));
    }

    _firestore
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .add(dataToSend);
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
      await _firestore.collection("chats").doc(id).set({
        'owner': _auth.currentUser?.email,
        'members': [_auth.currentUser?.email]
      });
      return true;
    }

    String salt = _generateRandomString(12);
    String saltedPasswordHash = Crypt.sha256(password, salt: salt).toString();

    await _firestore.collection("chats").doc(id).set({
      'owner': _auth.currentUser?.email,
      'members': [_auth.currentUser?.email],
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

  Future<bool> isLockedForUser(String id) async {
    var snapshot = await _firestore.collection("chats").doc(id).get();
    var data = snapshot.data();
    List<dynamic> members = data?['members'];
    var currentUser = _auth.currentUser?.email;
    return (data!.containsKey("passwordSecured") &&
            !members.contains(currentUser))
        ? true
        : false;
  }

  Future<bool> unlockForCurrentUser(String chatId, String password) async {
    var snapshot = await _firestore.collection("chats").doc(chatId).get();
    var data = snapshot.data();
    String salt = data!['salt'];
    String storedPassword = data['password'];

    String saltedPasswordHash = Crypt.sha256(password, salt: salt).toString();

    List<dynamic> members = data['members'];
    var currentUser = _auth.currentUser?.email;

    bool currentUserIsAMember = members.contains(currentUser);

    if (saltedPasswordHash != storedPassword) {
      return false;
    }

    if (!currentUserIsAMember) {
      _firestore.collection("chats").doc(chatId).update({
        "members": FieldValue.arrayUnion([_auth.currentUser?.email])
      });
      ;
    }

    return true;
  }

  Future<void> addMember(String id) async {
    var snapshot = await _firestore.collection("chats").doc(id).get();
    var data = snapshot.data();
    List<dynamic> members = data?['members'];
    var currentUser = _auth.currentUser?.email;
    if (members.contains(currentUser)) {
      return;
    }
    await _firestore.collection("chats").doc(id).update({
      "members": FieldValue.arrayUnion([currentUser])
    });
  }
}

//
