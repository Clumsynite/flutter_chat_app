import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_avatar.dart';
import 'package:flutter_chat_app/common/widgets/empty_screen.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/mesaging/screens/messaging_screen.dart';
import 'package:flutter_chat_app/features/mesaging/services/friends_screen_services.dart';
import 'package:flutter_chat_app/models/friend.dart';
import 'package:flutter_chat_app/socket_client.dart';

class FriendsScreen extends StatefulWidget {
  final String id;
  const FriendsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendsScreenServices friendsScreenServices = FriendsScreenServices();

  SocketClient client = SocketClient();
  List<Friend> friends = [];
  bool isLoading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllFriends();
    listenToUserPresence();
  }

  void listenToUserPresence() {
    // switch isOnline when friend is online
    client.socket.on('${widget.id}_online', (userId) {
      int index = friends.indexWhere((Friend friend) => friend.id == userId);
      friends[index] = friends[index].copyWith(isOnline: true);
      setState(() {});
    });

    // switch isOnline when friend goes offline
    client.socket.on('${widget.id}_offline', (userId) {
      int index = friends.indexWhere((Friend friend) => friend.id == userId);
      friends[index] = friends[index].copyWith(
        isOnline: false,
        lastSeen: DateTime.now().toIso8601String(),
      );
      setState(() {});
    });

    client.socket.on('${widget.id}_friend', (userId) {
      fetchAllFriends();
    });

    // switch isOnline when friend goes offline
    client.socket.on('${widget.id}_friend_typing', (data) {
      if (data['userId'] != widget.id) {
        int index =
            friends.indexWhere((Friend friend) => friend.id == data['userId']);
        friends[index] = friends[index].copyWith(isTyping: data['isTyping']);
        setState(() {});
      }
    });

    client.socket.on('${widget.id}_unread', (userId) {
      int index = friends.indexWhere((Friend friend) => friend.id == userId);
      Friend oldFriend = friends[index];
      friends[index] =
          friends[index].copyWith(unreadCount: oldFriend.unreadCount + 1);
      setState(() {});
    });

    client.socket.on('${widget.id}_read', (userId) {
      int index = friends.indexWhere((Friend friend) => friend.id == userId);
      Friend oldFriend = friends[index];
      friends[index] =
          friends[index].copyWith(unreadCount: oldFriend.unreadCount - 1);
      setState(() {});
    });
  }

  void fetchAllFriends() async {
    setState(() {
      isLoading = true;
    });
    friends = await friendsScreenServices.getAllFriends(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    client.socket.off('${widget.id}_online');
    client.socket.off('${widget.id}_offline');
    client.socket.off('${widget.id}_friend');
    client.socket.off('${widget.id}_friend_typing');
    client.socket.off('${widget.id}_read');
    client.socket.off('${widget.id}_unread');
    super.dispose();
  }

  void navigateToMessagingScreen(Friend friend) {
    Navigator.pushNamed(
      context,
      MessagingScreen.routeName,
      arguments: MessagingScreenArguments(
        friend,
        widget.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loader()
        : friends.isEmpty
            ? const EmptyScreen(text: "Your Friend List is Empty")
            : Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Your Friends",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          Friend friend = friends[index];
                          return ListTile(
                            onTap: () => navigateToMessagingScreen(friend),
                            leading: Badge(
                              position: BadgePosition.bottomEnd(
                                bottom: 0,
                                end: 0,
                              ),
                              badgeColor: friend.isOnline
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              child: CustomAvatar(
                                username: friend.username[0].toUpperCase(),
                              ),
                            ),
                            title: Text(
                              friend.username,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: friend.isTyping
                                ? const Text(
                                    "typing...",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    friend.isOnline
                                        ? "Online"
                                        : getRelativeTime(
                                            friend.lastSeen ?? "",
                                          ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                            trailing: friend.unreadCount > 0
                                ? Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      friend.unreadCount < 100
                                          ? friend.unreadCount.toString()
                                          : "99+",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
}
