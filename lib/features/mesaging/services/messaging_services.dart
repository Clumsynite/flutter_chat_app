import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessagingServices {
  Future<List<Message>> getAllMessages({
    required BuildContext context,
    required String friendId,
  }) async {
    List<Message> messages = [];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.get(
        Uri.parse('$uri/message/from/$friendId'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      var decodedRes = jsonDecode(res.body);
      for (int i = 0; i < decodedRes.length; i++) {
        var currentMessage = decodedRes[i];
        Message message = Message.fromJson(jsonEncode(currentMessage));
        messages.add(message);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return messages;
  }

  Future<Message?> sendMessage({
    required BuildContext context,
    required String to,
    required String text,
  }) async {
    Message? message;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.post(
        Uri.parse('$uri/message'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
        body: jsonEncode(
          {
            'to': to,
            'text': text,
          },
        ),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          message = Message.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return message;
  }

  void deleteMessage({
    required BuildContext context,
    required String ids,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.delete(
        Uri.parse('$uri/message/$ids'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void deleteAllMessages({
    required BuildContext context,
    required String friendId,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.delete(
        Uri.parse('$uri/message/from/$friendId'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
