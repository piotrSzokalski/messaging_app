import 'dart:async';
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
  // ignore: no_logic_in_create_state
  State<ChannelPage> createState() => _ChannelPage(id);
}

class _ChannelPage extends State<ChannelPage> {
  String? _id;

  final List<XFile> _imagesToSend = [];

  _ChannelPage(this._id);

  final TextEditingController _inputController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final StreamController<List<Message>> _messagesStreamController =
      StreamController();

  final List<Message> _messagesList = [];

  Timestamp _oldestMessageTimeStamp = Timestamp.now();

  void _showSendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Sending message...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void _hideSendingDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _sendMessage() async {
    String? username = await Provider.of<UserService>(context, listen: false)
        .getUserName()
        .first;

    _showSendingDialog();

    // ignore: use_build_context_synchronously
    await Provider.of<ChatService>(context, listen: false).sendMessage(
        chatId: _id,
        author: username,
        text: _inputController.text,
        images: _imagesToSend);
    _hideSendingDialog();

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

  _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      Provider.of<ChatService>(context, listen: false)
          .getMessages(_id!, _oldestMessageTimeStamp)
          .then((messages) => _messagesList.addAll(messages))
          .then((value) => _messagesStreamController.add(_messagesList))
          .then((value) {
        if (_messagesList.isNotEmpty) {
          _oldestMessageTimeStamp = _messagesList.last.timestamp!;
        }
      });
    }
  }

  void _openImageViewer(Image image) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Material(
              type: MaterialType.transparency,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Center(child: image),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserService>(context, listen: false).addChannelTotVisited(_id!);
    _scrollController.addListener(_onScroll);

    _messagesStreamController.add(_messagesList);
    Provider.of<ChatService>(context, listen: false)
        .getMessages(_id!, null)
        .then((messages) => _messagesList.addAll(messages))
        .then((value) => _messagesList.removeAt(0))
        .then((value) => _messagesStreamController.add(_messagesList))
        .then((value) {
      if (_messagesList.isNotEmpty) {
        _oldestMessageTimeStamp = _messagesList.last.timestamp!;
      }
    });

    Provider.of<ChatService>(context, listen: false)
        .getMessagesStream(_id!)
        ?.listen((event) {
      if (event.isNotEmpty) {
        _messagesList.insert(0, event[0]);
        if (_messagesList.length > 1) {
          if (_messagesList[0] == _messagesList[1]) {
            _messagesList.removeAt(1);
          }
        }
        _messagesStreamController.add(_messagesList);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _messagesStreamController.close();

    super.dispose();
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
        width: double.infinity,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_imagesToSend.isNotEmpty)
              SizedBox(
                height: 200,
                child: buildInputImagesPreview(),
              ),
            Row(
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
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                    controller: _inputController,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => _addImage(ImageSource.gallery),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => _addImage(ImageSource.camera),
                ),
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
          ],
        ),
      ),
    );
  }

  ListView buildInputImagesPreview() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imagesToSend.length,
        itemBuilder: (context, index) {
          return SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Image.file(File(_imagesToSend[index].path),
                      height: 100, width: 100, fit: BoxFit.cover),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeImage(index),
                      ))
                ],
              ));
        });
  }

  StreamBuilder<List<Message>> buildMessages(BuildContext context) {
    return StreamBuilder(
      stream: _messagesStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          List<Message> messages = snapshot.data as List<Message>;

          if (messages.length > 1) {
            if (messages[0] == messages[1]) {
              messages.removeAt(1);
            }
          }

          if (messages.isEmpty) {
            return const Text("No messages available");
          }

          return ListView.builder(
            controller: _scrollController,
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
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                    height: 200,
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Text('Error loading image');
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    _openImageViewer(Image.network(image));
                                  },
                                  child: SizedBox(
                                      height: 200, child: Image.network(image)),
                                );
                              }
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
