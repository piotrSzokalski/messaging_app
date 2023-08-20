import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/models/user.dart';

class Message {
  String? id;
  Timestamp? timestampl;
  User? author;
  String? text;
}
