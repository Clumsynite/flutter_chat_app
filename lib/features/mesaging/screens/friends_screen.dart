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
      friends[index] = friends[index].copyWith(isOnline: false);
      setState(() {});
    });

    client.socket.on('${widget.id}_friend', (userId) {
      fetchAllFriends();
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
                            subtitle: Text(
                              // friend.email,
                              getRelativeTime(friend.lastSeen ?? ""),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
  }
}
