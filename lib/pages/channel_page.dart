import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:messaging_app/services/user_service.dart';
import 'package:provider/provider.dart';

class ChannelPage extends StatefulWidget {
  String? id;
  ChannelPage({super.key, this.id});

  @override
  State<ChannelPage> createState() => _ChannelPage(id);
}

class _ChannelPage extends State<ChannelPage> {
  String? _id;

  _ChannelPage(this._id);

  TextEditingController _inputController = TextEditingController();

  void _sendMessage() async {
    String? username = await Provider.of<UserService>(context, listen: false)
        .getUserName()
        .first;

    if (username != null) {
      Provider.of<ChatService>(context, listen: false).sendMessage(
          chatId: _id, author: username, text: _inputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_id!),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessages(context)),
          buildInput(),
        ],
      ),
    );
  }

  Align buildInput() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
                controller: _inputController,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: _sendMessage,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<Message>> buildMessages(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<ChatService>(context).getMessages(_id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          List<Message> messages = snapshot.data as List<Message>;

          if (messages.isEmpty) {
            return const Text("No messages available");
          }

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              Message message = messages[index];
              return Container(
                padding: const EdgeInsets.only(
                    left: 0, right: 14, top: 10, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          message.author ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          message.timestamp!
                              .toDate()
                              .toLocal()
                              .toString()
                              .substring(0, 16),
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(message.text ?? "E"),
                      ),
                    ),
                  ]),
                ),
              );
            },
          );
        } else {
          return const Text("No data");
        }
      },
    );
  }
}
