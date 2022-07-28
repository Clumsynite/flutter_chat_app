import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/contacts/screens/contacts_screen.dart';
import 'package:flutter_chat_app/features/friend_requests/screens/friend_requests_screen.dart';
import 'package:flutter_chat_app/features/home/services/home_services.dart';
import 'package:flutter_chat_app/features/mesaging/screens/friends_screen.dart';
import 'package:flutter_chat_app/socket_client.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  final String id;
  const HomeScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeServices homeServices = HomeServices();
  final SocketClient client = SocketClient();
  int _currentPage = 0;
  int friendRequestCount = 0;

  List<Widget> _pages(String id) {
    return [
      FriendsScreen(id: id),
      const ContactsScreen(),
      const Center(
        child: Text("Tab 3"),
      ),
    ];
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void fetchFriendRequestCount() async {
    friendRequestCount =
        await homeServices.getFriendRequestCount(context: context);
    setState(() {});
    listenToFriendRequests();
  }

  void updatePage(int page) {
    fetchFriendRequestCount();
    setState(() {
      _currentPage = page;
    });
  }

  void listenToFriendRequests() {
    client.socket.on('${widget.id}_friend', (data) {
      fetchFriendRequestCount();
    });
  }

  void listenToForceLogout() {
    client.socket.on('${widget.id}_logout', (data) {
      if (mounted) {
        showSnackBar(context, "Force logged out by another device!");
        onLogout(false);
      }
    });
  }

  @override
  void initState() {
    fetchFriendRequestCount();
    super.initState();
    client.notifyUserOnline(widget.id);
    listenToForceLogout();
  }

  @override
  void dispose() {
    client.socket.off('${widget.id}_friend');
    // client.socket.off('${widget.id}_logout');
    super.dispose();
  }

  void onLogout(bool byUser) {
    HomeServices().logout(
      context: context,
      onSuccess: client.notifyUserOffline,
      byUser: byUser,
    );
  }

  void navigateToFriendRequestScreen() {
    Navigator.pushNamed(context, FriendRequestsScreen.routeName);
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
            "Flutter Chat App",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: navigateToFriendRequestScreen,
              icon: Badge(
                showBadge: friendRequestCount > 0,
                badgeContent: Text(
                  friendRequestCount.toString(),
                ),
                child: const Icon(
                  Icons.group_add_outlined,
                ),
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => onLogout(true),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: 16,
                      ),
                      Text(
                        "Logout",
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: _pages(widget.id)[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline),
            label: "Messages",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
        onTap: updatePage,
      ),
    );
  }
}
