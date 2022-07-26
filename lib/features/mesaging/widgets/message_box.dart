import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message.dart';

class MessageBox extends StatefulWidget {
  final Message message;
  final String friendId;
  final String id;
  const MessageBox({
    Key? key,
    required this.message,
    required this.friendId,
    required this.id,
  }) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
