import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/auth/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  void logout({
    required BuildContext context,
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(tokenKey, '');
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
