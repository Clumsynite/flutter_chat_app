import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/friend_requests/service/friend_request_services.dart';
import 'package:flutter_chat_app/models/friend_request.dart';

class FriendRequestsScreen extends StatefulWidget {
  static const String routeName = "/friend-requests";
  const FriendRequestsScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final FriendRequestServices friendRequestServices = FriendRequestServices();
  List<FriendRequest> friendRequests = [];
  bool isLoading = false;
  List<String> handlingRequests = [];

  @override
  void initState() {
    super.initState();
    fetchAllRequests();
  }

  void fetchAllRequests() async {
    setState(() {
      isLoading = true;
    });
    friendRequests =
        await friendRequestServices.getReceviedFriendRequests(context: context);
    setState(() {
      isLoading = false;
    });
  }

  void acceptFriendRequest(String id) async {
    if (handlingRequests.contains(id)) {
      int index = friendRequests.indexWhere(
        (element) => element.id == id,
      );
      FriendRequest friendRequest = friendRequests[index];
      return showSnackBar(context,
          '${friendRequest.contact.username}\'s request is already being processed');
    }
    handlingRequests.add(id);
    setState(() {});
    await friendRequestServices.acceptFriendRequest(
      context: context,
      id: id,
      onSuccess: () {
        friendRequests.removeWhere(
          (FriendRequest friendRequest) => friendRequest.id == id,
        );
        setState(() {});
      },
    );
    handlingRequests.removeWhere((element) => element == id);
    setState(() {});
  }

  void cancelFriendRequest(String id) async {
    if (handlingRequests.contains(id)) {
      int index = friendRequests.indexWhere(
        (element) => element.id == id,
      );
      FriendRequest friendRequest = friendRequests[index];
      return showSnackBar(context,
          '${friendRequest.contact.username}\'s request is already being processed');
    }
    handlingRequests.add(id);
    setState(() {});
    await friendRequestServices.cancelFriendRequest(
      context: context,
      id: id,
      onSuccess: () {
        friendRequests.removeWhere(
          (FriendRequest friendRequest) => friendRequest.id == id,
        );
        setState(() {});
      },
    );
    handlingRequests.removeWhere((element) => element == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalConfig.appBarGradient,
            ),
          ),
          title: const Text(
            "Friend Requests",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Loader()
          : friendRequests.isEmpty
              ? const Center(
                  child: Text(
                    "No New Friend Requests",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Friend Requests from:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: friendRequests.length,
                          itemBuilder: (context, index) {
                            FriendRequest friendRequest = friendRequests[index];
                            return ListTile(
                              leading: SizedBox(
                                height: double.infinity,
                                child: CircleAvatar(
                                  backgroundColor: GlobalConfig().randomColour,
                                  child: Text(
                                    friendRequest.contact.username[0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                friendRequest.contact.username,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                friendRequest.contact.email,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 90,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => cancelFriendRequest(
                                            friendRequest.id),
                                        icon: const Icon(
                                          Icons.cancel_outlined,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                        tooltip: "Cancel Request",
                                      ),
                                      // const SizedBox(width: 5),
                                      IconButton(
                                        onPressed: () => acceptFriendRequest(
                                            friendRequest.id),
                                        icon: const Icon(
                                          Icons.check_circle_outlined,
                                          size: 30,
                                          color: Colors.green,
                                        ),
                                        tooltip: "Accept Request",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
