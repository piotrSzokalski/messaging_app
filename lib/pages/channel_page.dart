import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/chats_service.dart';

class ChannelPage extends StatefulWidget {
  String? id;
  ChannelPage({super.key, this.id});

  @override
  State<ChannelPage> createState() => _ChannelPage(id);
}

class _ChannelPage extends State<ChannelPage> {
  String? _id;

  _ChannelPage(this._id);

  @override
  Widget build(BuildContext context) {
    ChatService chatService = ChatService();
    var x = chatService.getMessages(_id!);
    print(x);

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text(_id!),
        StreamBuilder(
            stream: x,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //var data = snapshot.data as List<String>;
                return Text(snapshot.data.toString());
              } else {
                return Text("No data");
              }
            })
      ]),
    );
  }
}
