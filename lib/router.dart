import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/features/auth/screens/auth_screen.dart';
import 'package:flutter_chat_app/features/friend/screens/friend_requests_screen.dart';
import 'package:flutter_chat_app/features/home/screens/home_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AuthScreen(),
        settings: routeSettings,
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const HomeScreen(),
        settings: routeSettings,
      );
    case FriendRequestsScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const FriendRequestsScreen(),
        settings: routeSettings,
      );

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Error 404!"),
          ),
        ),
        settings: routeSettings,
      );
  }
}
