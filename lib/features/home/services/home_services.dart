import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/auth/screens/auth_screen.dart';
import 'package:flutter_chat_app/models/user.dart';
import 'package:flutter_chat_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  void logout({
    required BuildContext context,
    required Function onSuccess,
    required bool byUser,
  }) async {
    try {
      User user = Provider.of<UserProvider>(context, listen: false).user;
      if (byUser) onSuccess(user.id);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(tokenKey, '');
      await sharedPreferences.setString(socketIdKey, '');
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<int> getFriendRequestCount({
    required BuildContext context,
  }) async {
    int friendRequestCount = 0;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.get(
        Uri.parse('$uri/friend-request/count'),
        headers: <String, String>{
          'Content-type': 'application/json; Character-type=UTF-8',
          tokenKey: token!
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          friendRequestCount = jsonDecode(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return friendRequestCount;
  }
}
