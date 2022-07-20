import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/models/friend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FriendsScreenServices {
  Future<List<Friend>> getAllFriends({
    required BuildContext context,
  }) async {
    List<Friend> friends = [];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.get(
        Uri.parse('$uri/friend/'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      var decodedRes = jsonDecode(res.body);
      for (int i = 0; i < decodedRes.length; i++) {
        var currentUser = decodedRes[i];
        Friend contact = Friend.fromJson(jsonEncode(currentUser));
        friends.add(contact);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return friends;
  }
}
