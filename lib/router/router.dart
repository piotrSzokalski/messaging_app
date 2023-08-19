import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:messaging_app/pages/login.dart';
import 'package:messaging_app/pages/channels.dart';
import 'package:messaging_app/pages/register.dart';

//register
final GoRouter router = GoRouter(
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
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null && state.fullPath.toString() != '/login/register') {
        return "/login";
      }
    });
