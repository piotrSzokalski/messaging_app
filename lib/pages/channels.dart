import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../router/router.dart';
import '../services/auth_service.dart';

class Channels extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Channels();
}

class _Channels extends State {
  var user = FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    print(router.configuration);
    print('______________________________');
    router.goNamed('login');
    print(router.configuration);

    return;
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.logout();
    FirebaseAuth.instance.idTokenChanges().listen((event) {
      print("going to login");
      router.goNamed("home");
    });
    router.goNamed("home");
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(leading: Icon(Icons.account_circle_rounded)),
        drawer: Drawer(
          child: ListView(children: [
            const DrawerHeader(
              child: Text("Header"),
            ),
            ListTile(
              title: const Text("Logout"),
              onTap: _logout,
            )
          ]),
        ),
        body: Center(
          child: Text(user.toString()),
        ),
      );
}
