import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/empty_screen.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/features/mesaging/services/friends_screen_services.dart';
import 'package:flutter_chat_app/models/friend.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FriendsScreenServices friendsScreenServices = FriendsScreenServices();

  List<Friend> friends = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllFriends();
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
                            leading: SizedBox(
                              height: double.infinity,
                              child: CircleAvatar(
                                backgroundColor: GlobalConfig().randomColour,
                                child: Text(
                                  friend.username[0].toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              friend.username,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              friend.email,
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
