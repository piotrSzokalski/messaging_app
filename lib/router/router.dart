import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:messaging_app/pages/channel_password_page.dart';
import 'package:messaging_app/pages/login.dart';
import 'package:messaging_app/pages/channels.dart';
import 'package:messaging_app/pages/register.dart';
import 'package:messaging_app/services/chats_service.dart';
import 'package:provider/provider.dart';

import '../pages/channel_page.dart';

//register
final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        name: 'home',
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return Channels();
        },
        routes: <RouteBase>[
          GoRoute(
              path: 'login',
              name: 'login',
              builder: (BuildContext context, GoRouterState state) {
                return Login();
              },
              routes: [
                GoRoute(
                  path: 'register',
                  name: 'register',
                  builder: (BuildContext context, GoRouterState state) {
                    return const Register();
                  },
                ),
              ]),
          GoRoute(
              path: "channel/:id",
              name: "channel",
              builder: (BuildContext context, GoRouterState state) {
                return ChannelPage(id: state.pathParameters['id']);
              },
              routes: []),
          GoRoute(
              path: "unlock/:id",
              name: 'unlock-channel',
              builder: (BuildContext context, GoRouterState state) {
                print("In router");
                var x = state.pathParameters['id'];
                return ChannelPasswordPage(id: x);
              })
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null && state.fullPath.toString() != '/login/register') {
        return "/login";
      }
    });
