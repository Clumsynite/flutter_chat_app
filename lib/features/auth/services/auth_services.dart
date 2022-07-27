// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/config/global_config.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/home/screens/home_screen.dart';
import 'package:flutter_chat_app/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  void signup({
    required BuildContext context,
    required String username,
    required String password,
    required String email,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8"
        },
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
        }),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Account created successfully!\nLogin with these credentials",
          );
        },
        onError: onError,
      );
    } catch (e) {
      onError();
      showSnackBar(context, e.toString());
    }
  }

  void signin({
    required BuildContext context,
    required String username,
    required String password,
    required VoidCallback onError,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8"
        },
        body: jsonEncode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(tokenKey, jsonDecode(res.body)['token']);

          String? socketId = prefs.getString(socketIdKey);

          bool isUserAlreadyActive = verifySocketId(
            socketId: socketId,
            userSocketId: jsonDecode(res.body)['socketId'],
          );
          if (!isUserAlreadyActive) {
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
              (route) => false,
              arguments: jsonDecode(res.body)["_id"],
            );
            await prefs.setString(
                socketIdKey, jsonDecode(res.body)['socketId'] ?? "");
          } else {
            onError();
            showSnackBar(context, GlobalConfig.socketErrorMsg);
            await prefs.setString(tokenKey, '');
          }
        },
        onError: onError,
      );
    } catch (e) {
      onError();
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUser({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      if (token == null) {
        prefs.setString(tokenKey, "");
      }
      http.Response res = await http.get(
        Uri.parse('$uri/api/is-token-valid'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      var response = jsonDecode(res.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/user'),
          headers: <String, String>{
            'Content-type': "application/json; charset=UTF-8",
            'x-auth-token': token
          },
        );

        String? socketId = prefs.getString(socketIdKey);
        bool isUserAlreadyActive = verifySocketId(
          socketId: socketId,
          userSocketId: jsonDecode(userRes.body)['socketId'],
        );
        if (!isUserAlreadyActive) {
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).setUser(userRes.body);
          await prefs.setString(
              socketIdKey, jsonDecode(res.body)['socketId'] ?? "");
        } else {
          showSnackBar(context, GlobalConfig.socketErrorMsg);
          await prefs.setString(tokenKey, '');
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  bool verifySocketId({
    required String? socketId,
    required String? userSocketId,
  }) {
    bool isUserAlreadyActive = true;
    if (socketId == null) {
      isUserAlreadyActive = false;
    } else if (socketId != userSocketId && userSocketId != null) {
      isUserAlreadyActive = true;
      // await prefs.setString(tokenKey, '');
    } else {
      if (userSocketId != null) {
        // await prefs.setString(socketIdKey, userSocketId);
      }
      isUserAlreadyActive = false;
    }
    return isUserAlreadyActive;
  }
}
