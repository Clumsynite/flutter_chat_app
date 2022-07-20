import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/models/friend_request.dart';
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

  Future<List<FriendRequest>> getReceviedFriendRequests({
    required BuildContext context,
  }) async {
    List<FriendRequest> friendRequests = [];
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.get(
        Uri.parse('$uri/friend-request/to'),
        headers: <String, String>{
          'Content-type': 'application/json; Character-type=UTF-8',
          tokenKey: token!
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // friendRequestCount = jsonDecode(res.body);
          var decodedRes = jsonDecode(res.body);
          // print('decodedRes $decodedRes');
          for (int i = 0; i < decodedRes.length; i++) {
            var decodedRequest = decodedRes[i];
            friendRequests.add(
              FriendRequest.fromJson(
                jsonEncode(decodedRequest),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return friendRequests;
  }

  Future<void> acceptFriendRequest({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);

      http.Response res = await http.post(
        Uri.parse('$uri/friend-request/accept'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
        body: jsonEncode(
          {
            '_id': id,
          },
        ),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
          showSnackBar(context, "Friend Request Accepted!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
