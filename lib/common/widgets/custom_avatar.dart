// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_chat_app/config/global_config.dart';

class CustomAvatar extends StatelessWidget {
  final String username;
  final double fontSize;
  final double radius;

  const CustomAvatar({
    Key? key,
    required this.username,
    this.fontSize = 20,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: GlobalConfig().randomColour,
      child: Text(
        username.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
