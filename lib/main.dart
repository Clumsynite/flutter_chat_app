import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/widgets/loader.dart';
import 'package:flutter_chat_app/features/auth/screens/auth_screen.dart';
import 'package:flutter_chat_app/features/auth/services/auth_services.dart';
import 'package:flutter_chat_app/features/home/screens/home_screen.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/provider/user_provider.dart';
import 'package:flutter_chat_app/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlutterChatApp(),
    );
  }
}

class FlutterChatApp extends StatefulWidget {
  const FlutterChatApp({Key? key}) : super(key: key);

  @override
  State<FlutterChatApp> createState() => _FlutterChatAppState();
}

class _FlutterChatAppState extends State<FlutterChatApp> {
  final AuthServices authServices = AuthServices();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  void checkIfLoggedIn() async {
    setState(() {
      isLoading = true;
    });
    await authServices.getUser(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return isLoading
        ? const Loader()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Flutter Chat App",
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                  // primary: Colors.black,
                  ),
              appBarTheme: const AppBarTheme(
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              // useMaterial3: true, // changes UI in all places
            ),
            onGenerateRoute: (settings) => generateRoute(settings),
            home:
                user.token.isNotEmpty ? const HomeScreen() : const AuthScreen(),
          );
  }
}
