// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/global_config.dart';

class CustomAvatar extends StatelessWidget {
  final String username;
  const CustomAvatar({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: GlobalConfig().randomColour,
      child: Text(
        username.toUpperCase(),
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
