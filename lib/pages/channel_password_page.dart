import 'package:flutter/material.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';

// ignore: must_be_immutable
class ChannelPasswordPage extends StatefulWidget {
  String? id;

  ChannelPasswordPage({super.key, this.id});
  //ChannelPasswordPage({Key? key, this.id}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<ChannelPasswordPage> createState() => _ChannelPasswordPageState(id);
}

class _ChannelPasswordPageState extends State<ChannelPasswordPage> {
  String? _id;

  final _channelPasswordController = TextEditingController();

  _ChannelPasswordPageState(this._id);

  void _unlockChannel() async {
    var respone = await Provider.of<ChatService>(context, listen: false)
        .unlockForCurrentUser(_id!, _channelPasswordController.text);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(respone ? "Password correct" : "Password Incorrect")));

    if (!respone) {
      return;
    }
    await Future.delayed(const Duration(seconds: 2));
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
            const Text(
              "This channel is protected by a password",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enter password to access",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _channelPasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _unlockChannel,
              child: const Text("Access Channel"),
            ),
          ],
        ),
      ),
    );
  }
}
