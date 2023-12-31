import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/models/user.dart';

class Message {
  String? id;
  Timestamp? timestamp;
  String? author;
  String? text;
  List<String> images;
  Message(
      {this.id, this.timestamp, this.author, this.text, required this.images});

  @override
  String toString() {
    return 'Message{id: $id, timestamp: $timestamp, author: $author, text: $text, images: }';
  }
}
