import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  List<XFile> _imagesToSend = [];

  _ChannelPage(this._id);

  TextEditingController _inputController = TextEditingController();

  void _sendMessage() async {
    String? username = await Provider.of<UserService>(context, listen: false)
        .getUserName()
        .first;

    if (username != null) {
      await Provider.of<ChatService>(context, listen: false).sendMessage(
          chatId: _id,
          author: username,
          text: _inputController.text,
          images: _imagesToSend);
    }

    setState(() {
      _inputController.clear();
      _imagesToSend.clear();
    });
  }

  void _addImage(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: imageSource);
    if (imageFile != null) {
      setState(() {
        _imagesToSend.add(imageFile);
        print(_imagesToSend);
      });
    }
  }

  void _removeImage(int index) {
    if (index < 0) {
      return;
    }
    setState(() {
      _imagesToSend.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserService>(context, listen: false).addChannelTotVisited(_id!);
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
        height: _imagesToSend.isEmpty ? 60 : 200,
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
              child: Container(
                height: 300,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: TextField(
                    style: const TextStyle(
                        height: 1.5, // change this to reflect the effect
                        fontSize: 20.0),
                    decoration: InputDecoration(
                        prefix: _imagesToSend.isNotEmpty
                            ? ListView.builder(
                                itemCount: _imagesToSend.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          Image.file(
                                              File(_imagesToSend[index].path),
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: Icon(Icons.close),
                                                onPressed: () =>
                                                    _removeImage(index),
                                              ))
                                        ],
                                      ));
                                })
                            : const Text(" "),
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                    controller: _inputController,
                  ),
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => _addImage(ImageSource.gallery)),
            IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _addImage(ImageSource.camera)),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: _sendMessage,
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
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
          return Column(
            children: [
              const Text(
                  'snapshot.connectionState == ConnectionState.waiting\n\n'),
              Text(snapshot.toString())
            ],
          );
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
                    if (message.images != [])
                      for (var image in message.images)
                        FutureBuilder(
                            future: precacheImage(NetworkImage(image), context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return CircularProgressIndicator();
                              else if (snapshot.hasError)
                                return Text('Error loading image');
                              else
                                return Image.network(image);
                            })
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
