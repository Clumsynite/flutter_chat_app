import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/features/contacts/screens/contacts_screen.dart';
import 'package:flutter_chat_app/features/friend/screens/friend_requests_screen.dart';
import 'package:flutter_chat_app/features/friend/service/friend_request_services.dart';
import 'package:flutter_chat_app/features/home/services/home_services.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FriendRequestServices friendRequestServices = FriendRequestServices();
  int _currentPage = 1;
  int friendRequestCount = 0;

  final List<Widget> _pages = const [
    Center(
      child: Text("Home"),
    ),
    ContactsScreen(),
    Center(
      child: Text("Tab 3"),
    ),
  ];

  void updatePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFriendRequestCount();
  }

  void onLogout() {
    HomeServices().logout(context: context);
  }

  void navigateToFriendRequestScreen() {
    Navigator.pushNamed(context, FriendRequestsScreen.routeName);
  }

  void fetchFriendRequestCount() async {
    friendRequestCount =
        await friendRequestServices.getFriendRequestCount(context: context);
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
                  onTap: onLogout,
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
      body: _pages[_currentPage],
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
