import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_avatar.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/mesaging/services/messaging_services.dart';
import 'package:flutter_chat_app/features/mesaging/widgets/message_box.dart';
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
  bool isFriendTyping = false;
  bool isSending = false;
  bool isLoading = false;
  List<Message> messages = [];
  List<String> selectedMessages = [];

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    friend = widget.friend;
    listenToUserPresence();
    getAllMessages();
    _focus.addListener(inputFocusListener);
  }

  void inputFocusListener() {
    client.notifyUserTyping(
      userId: widget.id,
      isTyping: _focus.hasFocus,
    );
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

    // switch isFriendTyping according to friend's response
    client.socket.on('${friend!.id}_typing', (isTyping) {
      setState(() {
        isFriendTyping = isTyping;
      });
    });

    // listen to messages which are sent to user from friend
    client.socket.on('message_to_${widget.id}_from_${friend!.id}', (message) {
      Message newMessage = Message.fromJson(jsonEncode(message));
      setState(() {
        messages.add(newMessage);
      });
      client.notifyMessageRead(newMessage.id);
      scrollToBottom();
    });
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  void getAllMessages() async {
    try {
      setState(() {
        isLoading = true;
      });
      messages = await messagingServices.getAllMessages(
        context: context,
        friendId: friend!.id,
      );
      setState(() {
        isLoading = false;
      });
      scrollToBottom();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendMessage() async {
    try {
      String text = _messageController.text;
      if (isSending || text.isEmpty) return;
      FocusScope.of(context).unfocus();
      setState(() {
        isSending = true;
      });
      Message? message = await messagingServices.sendMessage(
        context: context,
        to: friend!.id,
        text: text,
      );
      if (message!.id.isNotEmpty) {
        messages.add(message);
        _messageController.clear();
        scrollToBottom();
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

  void onSelectMessage(Message message) {
    int index = selectedMessages.indexOf(message.id);

    if (index == -1) {
      selectedMessages.add(message.id);
    } else {
      selectedMessages.removeAt(index);
    }
    setState(() {});
  }

  void deleteSelectedMessages() {
    String? error;
    for (int i = 0; i < selectedMessages.length; i++) {
      Message currentMessage =
          messages.singleWhere((element) => element.id == selectedMessages[i]);
      if (![widget.id, friend!.id].contains(currentMessage.from) ||
          ![widget.id, friend!.id].contains(currentMessage.to)) {
        error = "Not Authorised";
      }
    }
    if (error != null) return showSnackBar(context, error);

    String selectedIds = selectedMessages.join("&");
    messagingServices.deleteMessage(context: context, ids: selectedIds);

    for (int i = 0; i < selectedMessages.length; i++) {
      messages
          .removeWhere((Message message) => message.id == selectedMessages[i]);
    }
    setState(() {
      selectedMessages = [];
    });
  }

  void clearSelctedMessages() {
    setState(() {
      selectedMessages = [];
    });
  }

  @override
  void dispose() {
    client.socket.off('${widget.id}_online');
    client.socket.off('${widget.id}_offline');
    client.socket.off('${friend!.id}_typing');
    client.socket.off('message_to_${widget.id}_from_${friend!.id}');
    _messageController.dispose();
    _focus.removeListener(inputFocusListener);
    _focus.dispose();
    _scrollController.dispose();
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
          title: selectedMessages.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Badge(
                      position: BadgePosition.bottomEnd(
                        bottom: 0,
                        end: 0,
                      ),
                      badgeColor: friend!.isOnline
                          ? Colors.greenAccent
                          : Colors.redAccent,
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
                              ? isFriendTyping
                                  ? "typing..."
                                  : "Online"
                              : getRelativeTime(friend!.lastSeen ?? ""),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  selectedMessages.length.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
          actions: selectedMessages.isEmpty
              ? null
              : [
                  IconButton(
                    onPressed: deleteSelectedMessages,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red.shade600,
                    ),
                  ),
                ],
          leading: selectedMessages.isEmpty
              ? null
              : IconButton(
                  onPressed: clearSelctedMessages,
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
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
              child: isLoading
                  ? const Loader()
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.only(bottom: 5),
                      itemCount: messages.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        Message message = messages[messages.length - 1 - index];
                        bool isSelected = selectedMessages.contains(message.id);
                        return GestureDetector(
                          onTap: () => selectedMessages.isEmpty
                              ? null
                              : onSelectMessage(message),
                          onLongPress: () => onSelectMessage(message),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 1),
                            decoration: BoxDecoration(
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.lightBlue.shade200,
                                      )
                                    ]
                                  : [],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: MessageBox(
                              message: message,
                              friendId: friend!.id,
                              id: widget.id,
                              isSelected: isSelected,
                            ),
                          ),
                        );
                      },
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
                      focusNode: _focus,
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 4,
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
