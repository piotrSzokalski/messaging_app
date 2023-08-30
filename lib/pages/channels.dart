import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:messaging_app/services/user_service.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';
import '../services/auth_service.dart';

//      ???????
class MessageModel extends ChangeNotifier {
  Stream<List<String>> get messagesStream async* {
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      yield List.generate(i, (index) => 'Message $index');
    }
  }
}

class Channels extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Channels();
}

class _Channels extends State {
  var user = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _errorMessage = "";

  bool _nameCorrect = false;

  final _newChannelNameController = TextEditingController();

  bool newChannelNameValid = false;

  ChatService chatService = new ChatService();

  Future<void> _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);

    authService.logout();
    FirebaseAuth.instance.idTokenChanges().listen((event) {
      print("going to login");
      router.goNamed("home");
    });
    router.goNamed("home");
  }

  void _openChannel(String id) {
    router.go("/channel/$id");
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {});
  }

  void _createChannel() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  void _opneChannelCreator(BuildContext context) {
    showDialog(
      context: context,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, setStateInsideDialog) {
            return AlertDialog(
              title: const Text("Name of channel"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _newChannelNameController,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setStateInsideDialog(() {
                          _errorMessage = "";
                        });
                      }
                      Provider.of<ChatService>(context, listen: false)
                          .nameAvailable(value)
                          .then((available) {
                        setStateInsideDialog(() {
                          _errorMessage = available
                              ? ""
                              : "The name is already taken. Please choose another name.";

                          _nameCorrect = available && value.isNotEmpty;
                        });
                      });
                    },
                  ),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
              actions: [
                _nameCorrect
                    ? IconButton(
                        onPressed: () async {
                          bool correct = await Provider.of<ChatService>(context,
                                  listen: false)
                              .createChannel(_newChannelNameController.text);
                          Navigator.pop(context);
                          _newChannelNameController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: "Channel added "));
                        },
                        icon: Icon(Icons.save),
                      )
                    : const Icon(Icons.save_outlined),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _newChannelNameController.addListener(() {
      print("TEST");
    });
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.account_circle_rounded),
          title: Text("channels"),
        ),
        drawer: buildDrawer(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _updateSearchQuery,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            buildChatList()
          ],
        ));
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(children: [
        DrawerHeader(
          child: Row(
            children: [
              Icon(Icons.account_circle_rounded),
              StreamBuilder(
                  stream: Provider.of<UserService>(context).getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data ?? "EE");
                    } else {
                      return Text("NO DATA");
                    }
                  })
            ],
          ),
        ),
        ListTile(
          title: const Text("Create new channel"),
          onTap: () => _opneChannelCreator(context),
        ),
        ListTile(
          title: const Text("Logout"),
          onTap: _logout,
        )
      ]),
    );
  }

  Expanded buildChatList() {
    return Expanded(
      child: StreamBuilder(
          stream: Provider.of<ChatService>(context).getChats(),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final chatsList = snapshot.data as List<String>;
              //print("_____________");
              //print(chatsList);
              return ListView.builder(
                  itemCount: chatsList.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Text(chatsList[index].toString()),
                        onTap: () => _openChannel(chatsList[index].toString()),
                      ));
            } else {
              return const Text('no data');
            }
          }),
    );
  }
}
