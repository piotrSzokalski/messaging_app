import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Channels extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Channels();
}

class _Channels extends State {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(user.toString()),
        ),
      );
}
