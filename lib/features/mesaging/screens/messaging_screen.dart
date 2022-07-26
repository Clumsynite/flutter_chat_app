import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_avatar.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/mesaging/services/messaging_services.dart';
import 'package:flutter_chat_app/models/friend.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:flutter_chat_app/socket_client.dart';

class MessagingScreenArguments {
  final Friend friend;
  final String id;
  MessagingScreenArguments(this.friend, this.id);
}

class MessagingScreen extends StatefulWidget {
  static const String routeName = "/messaging";
  final Friend friend;
  final String id;
  const MessagingScreen({
    Key? key,
    required this.friend,
    required this.id,
  }) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final MessagingServices messagingServices = MessagingServices();
  SocketClient client = SocketClient();
  Friend? friend;
  final TextEditingController _messageController = TextEditingController();
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    friend = widget.friend;
    listenToUserPresence();
  }

  void listenToUserPresence() {
    // switch isOnline when friend is online
    client.socket.on('${widget.id}_online', (userId) {
      friend = widget.friend.copyWith(isOnline: true);
      setState(() {});
    });

    // switch isOnline when friend goes offline
    client.socket.on('${widget.id}_offline', (userId) {
      friend = widget.friend.copyWith(isOnline: false);
      setState(() {});
    });
  }

  void sendMessage() async {
    try {
      String text = _messageController.text;
      if (isSending || text.isEmpty) return;

      setState(() {
        isSending = true;
      });
      Message? message = await messagingServices.sendMessage(
        context: context,
        to: friend!.id,
        text: text,
      );
      if (message!.id.isNotEmpty) {
        // TODO: add message to messages array
        _messageController.clear();
      }
      setState(() {
        isSending = false;
      });
    } catch (e) {
      setState(() {
        isSending = false;
      });
    }
  }

  @override
  void dispose() {
    client.socket.off('${widget.id}_online');
    client.socket.off('${widget.id}_offline');
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalConfig.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Badge(
                position: BadgePosition.bottomEnd(
                  bottom: 0,
                  end: 0,
                ),
                badgeColor:
                    friend!.isOnline ? Colors.greenAccent : Colors.redAccent,
                child: CustomAvatar(
                  username: friend!.username[0].toUpperCase(),
                  fontSize: 14,
                  radius: 14,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend!.username,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    friend!.isOnline
                        ? "Online"
                        : getRelativeTime(friend!.lastSeen ?? ""),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // width: double.infinity,
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.lightBlue[50],
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      100,
                      (index) => Text('Index is $index'),
                    ).toList(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blue[50],
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 2,
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Start typing...',
                      ),
                      // autofocus: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  splashColor: Colors.green,
                  icon: Icon(
                    Icons.send_rounded,
                    color: isSending ? Colors.blue[100] : Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),

      // bottomNavigationBar:
    );
  }
}
