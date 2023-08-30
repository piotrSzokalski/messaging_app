import 'package:flutter/material.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';

class ChannelPasswordPage extends StatefulWidget {
  String? id;

  ChannelPasswordPage({super.key, this.id});
  //ChannelPasswordPage({Key? key, this.id}) : super(key: key);

  @override
  State<ChannelPasswordPage> createState() => _ChannelPasswordPageState(id);
}

class _ChannelPasswordPageState extends State<ChannelPasswordPage> {
  String? _id;

  final _channelPasswordController = TextEditingController();

  _ChannelPasswordPageState(this._id);

  void _unlockChannel() async {
    var respone = await Provider.of<ChatService>(context, listen: false)
        .unlockForCurrentUser(_id!, _channelPasswordController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(respone ? "Password correct" : "Password Incorrect")));

    if (!respone) {
      return;
    }
    await Future.delayed(Duration(seconds: 2));
    router.go("/channel/$_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_id ?? "NO id somechow"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This channel is protected by a password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Enter password to access",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _channelPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _unlockChannel,
              child: Text("Access Channel"),
            ),
          ],
        ),
      ),
    );
  }
}
