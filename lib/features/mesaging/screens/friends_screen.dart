import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/custom_avatar.dart';
import 'package:flutter_chat_app/common/widgets/empty_screen.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/mesaging/screens/messaging_screen.dart';
import 'package:flutter_chat_app/features/mesaging/services/friends_screen_services.dart';
import 'package:flutter_chat_app/models/friend.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/provider/user_provider.dart';
import 'package:flutter_chat_app/socket_client.dart';
import 'package:provider/provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

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
    User user = Provider.of<UserProvider>(context, listen: false).user;

    // switch isOnline when friend is online
    client.socket.on('${user.id}_online', (userId) {
      int index = friends.indexWhere((Friend friend) => friend.id == userId);
      friends[index] = friends[index].copyWith(isOnline: true);
      setState(() {});
    });

    // switch isOnline when friend goes offline
    client.socket.on('${user.id}_offline', (userId) {
      int index = friends.indexWhere((Friend friend) => friend.id == userId);
      friends[index] = friends[index].copyWith(isOnline: false);
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

  void navigateToMessagingScreen(Friend friend) {
    Navigator.pushNamed(
      context,
      MessagingScreen.routeName,
      arguments: friend,
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
