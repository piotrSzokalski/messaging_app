import 'dart:core';
import 'dart:collection';

import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/models/user.dart';

class Chat {
  String? id;
  List<User>? members;
  List<Message>? messages;

  Chat({this.id, this.members, this.messages});
}
