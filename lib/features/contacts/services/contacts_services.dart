import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/models/contact.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContactsServices {
  Future<List<Contact>> getAllUsers({
    required BuildContext context,
  }) async {
    List<Contact> contacts = [];
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);
      http.Response res = await http.get(
        Uri.parse('$uri/user/all'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      var decodedRes = jsonDecode(res.body);
      for (int i = 0; i < decodedRes.length; i++) {
        var currentUser = decodedRes[i];
        Contact contact = Contact.fromJson(jsonEncode(currentUser));
        contacts.add(contact);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return contacts;
  }

  void sendFriendRequest({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);

      http.Response res = await http.post(
        Uri.parse('$uri/friend'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
        body: jsonEncode({'to': id}),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
          showSnackBar(context, "Friend Request Sent");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void cancelFriendRequest({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(tokenKey);

      http.Response res = await http.delete(
        Uri.parse('$uri/friend/$id'),
        headers: <String, String>{
          'Content-type': "application/json; charset=UTF-8",
          tokenKey: token!
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
          showSnackBar(context, "Friend Request Cancelled!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
