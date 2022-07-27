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
    final bool wasSent = widget.message.from != widget.id;
    // bool wasSent = Random().nextInt(100) % 2 == 0;

    LinearGradient sentGradient = const LinearGradient(colors: [
      // Color(0xff219EBC),
      Color(0xff4cb6e1),
      Color(0xff8ECAE6),
      // Color(0xffa8e8f9),
    ]);

    LinearGradient receivedGradient = const LinearGradient(colors: [
      Color(0xffa8e8f9),
      Color(0xff4cb6e1),
    ]);

    return Row(
      children: [
        if (wasSent) const Spacer(flex: 1),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient: wasSent ? sentGradient : receivedGradient,
                  borderRadius: BorderRadius.circular(4)),
              child: Container(
                // width: 50,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: widget.message.text,
                      child: Text(
                        widget.message.text,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (!wasSent) const Spacer(flex: 1),
      ],
    );
  }
}
