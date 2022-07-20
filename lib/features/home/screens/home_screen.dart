import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/features/contacts/screens/contacts_screen.dart';
import 'package:flutter_chat_app/features/home/services/home_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPage = 1;

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
  }

  void onLogout() {
    HomeServices().logout(context: context);
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
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
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
                  onTap: onLogout,
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
