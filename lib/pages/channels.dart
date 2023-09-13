import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/message.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:messaging_app/services/user_service.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';
import '../services/auth_service.dart';

class Channels extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Channels();
}

class _Channels extends State {
  var user = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _errorMessage = "";

  bool _nameCorrect = false;

  bool _secureWihtPassword = false;

  final _newChannelNameController = TextEditingController();

  final _channelPasswordController = TextEditingController();

  final _searchQueryController = TextEditingController();

  bool newChannelNameValid = false;

  ChatService chatService = new ChatService();

  //List<String> visited = [];

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

  void _openChannel(String id) async {
    bool protected = await Provider.of<ChatService>(context, listen: false)
        .isLockedForUser(id);
    if (protected) {
      print(id);
      router.go("/unlock/$id");
      return;
    }
    // ignore: use_build_context_synchronously
    await Provider.of<ChatService>(context, listen: false).addMember(id);
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
                  Row(
                    children: [
                      Text("Secure with password?"),
                      Checkbox(
                          value: _secureWihtPassword,
                          onChanged: (onChanged) => setStateInsideDialog(
                              () => _secureWihtPassword = onChanged!)),
                    ],
                  ),
                  if (_secureWihtPassword)
                    TextFormField(
                      controller: _channelPasswordController,
                    )
                ],
              ),
              actions: [
                _nameCorrect
                    ? IconButton(
                        onPressed: () async {
                          String? password = _secureWihtPassword
                              ? _channelPasswordController.text
                              : null;
                          bool correct = await Provider.of<ChatService>(context,
                                  listen: false)
                              .createChannel(
                                  id: _newChannelNameController.text,
                                  password: password);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          _newChannelNameController.clear();
                          _channelPasswordController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Chat added")));
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
    return FutureBuilder(
      future:
          Provider.of<UserService>(context, listen: false).getVisitedChannels(),
      builder: (context, snapshot) {
        final visitedChannels = snapshot.data;
        print(visitedChannels);
        return Scaffold(
            appBar: AppBar(
              leading: Icon(Icons.account_circle_rounded),
              title: Text("channels"),
            ),
            drawer: buildDrawer(),
            body: Column(
              children: [
                //Text(visied.toString()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchQueryController,
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
                buildChatList(visitedChannels)
              ],
            ));
      },
    );
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

  Expanded buildChatList(dynamic visitedChannels) {
    return Expanded(
      child: StreamBuilder(
          stream: Provider.of<ChatService>(context)
              .getChats(_searchQueryController.text),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final chatsList = snapshot.data as List<Map<String, dynamic>>;
              return ListView.builder(
                  itemCount: chatsList.length,
                  itemBuilder: (context, index) {
                    bool visited = (visitedChannels as List<String>)
                        .contains(chatsList[index]['id']);
                    return ListTile(
                      title: Text(
                        chatsList[index]['id'].toString(),
                        style: TextStyle(
                            color: visited ? Colors.blue : Colors.black),
                      ),
                      trailing: Visibility(
                          visible: chatsList[index]['locked'] == true,
                          child: Icon(visited ? Icons.lock_open : Icons.lock)),
                      onTap: () =>
                          _openChannel(chatsList[index]['id'].toString()),
                    );
                  });
            } else {
              return const Text('no data');
            }
          }),
    );
  }
}
