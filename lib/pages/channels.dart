import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:messaging_app/services/user_service.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';
import '../services/auth_service.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
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
          onTap: () => router.push("/"),
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
