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
        path: '/',
        name: 'home',
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
          ),
          GoRoute(
            path: 'register',
            builder: (BuildContext context, GoRouterState state) {
              return const Register();
            },
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      var user = FirebaseAuth.instance.currentUser;
      final bool onLoginPage = state.path == '/login';
      if (user == null && !onLoginPage) {
        return "/login";
      }
      if (user != null && onLoginPage) {
        return 'home';
      }
    });
