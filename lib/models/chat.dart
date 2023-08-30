import 'dart:core';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/user.dart';

class Chat {
  String? id;
  Stream<User>? members;
  Stream<Message>? messages;

  Chat({this.id, this.members, this.messages});
}
