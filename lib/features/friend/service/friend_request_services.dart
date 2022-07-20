import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FriendRequestServices {
  Future<int> getFriendRequestCount({
    required BuildContext context,
  }) async {
    int friendRequestCount = 0;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.get(
        Uri.parse('$uri/friend/count'),
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
