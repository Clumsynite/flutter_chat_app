import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/auth/screens/auth_screen.dart';
import 'package:flutter_chat_app/features/friend_requests/screens/friend_requests_screen.dart';
import 'package:flutter_chat_app/features/home/screens/home_screen.dart';
import 'package:flutter_chat_app/features/mesaging/screens/messaging_screen.dart';
import 'package:flutter_chat_app/models/friend.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const AuthScreen(),
        settings: routeSettings,
      );
    case HomeScreen.routeName:
      String id = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => HomeScreen(id: id),
        settings: routeSettings,
      );
    case FriendRequestsScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const FriendRequestsScreen(),
        settings: routeSettings,
      );
    case MessagingScreen.routeName:
      MessagingScreenArguments arguments =
          routeSettings.arguments as MessagingScreenArguments;
      return MaterialPageRoute(
        builder: (_) => MessagingScreen(
          friend: arguments.friend,
          id: arguments.id,
        ),
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
