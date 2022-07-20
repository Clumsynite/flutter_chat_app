import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/empty_screen.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/models/friend.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<Friend> friends = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : friends.isEmpty
            ? const EmptyScreen(text: "Your Friend List is Empty")
            : Container();
  }
}
