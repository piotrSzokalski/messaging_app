import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/services/chats_service.dart';
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

  @override
  Widget build(BuildContext context) {
    // ChatService chatService = ChatService();
    // var x = chatService.getMessages(_id!);
    // print(x);

    // return Scaffold(
    //   appBar: AppBar(),
    //   body: Column(children: [
    //     Text(_id!),
    //     StreamBuilder(
    //         stream: Provider.of<ChatService>(context).getMessages(_id!),
    //         builder: (context, snapshot) {
    //           if (snapshot.connectionState == ConnectionState.waiting) {
    //             return CircularProgressIndicator();
    //           } else if (snapshot.hasData) {
    //             //Create list with placeholders
    //           } else {
    //             return Text("No data");
    //           }
    //         })
    //   ]),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text(_id!),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessages(context)),
          Align(
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
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
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
          ),
        ],
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

          // Create a list to accumulate the ListTile widgets
          List<Widget> listItems = [];

          for (Message message in messages) {
            listItems.add(Container(
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
                          child: Text(message.text ?? "E"))),
                ]),
              ),
            ));
          }

          return Column(
            children: listItems,
          );
        } else {
          return const Text("No data");
        }
      },
    );
  }
}
