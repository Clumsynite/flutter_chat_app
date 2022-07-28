// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;

class ProfileServices {
  Future<void> updateUserDetails({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
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
        http.Response userRes = await http.put(
          Uri.parse('$uri/user/details'),
          headers: <String, String>{
            'Content-type': "application/json; charset=UTF-8",
            'x-auth-token': token
          },
          body: jsonEncode(
            {
              'firstName': firstName,
              'lastName': lastName,
              'email': email,
            },
          ),
        );
        httpErrorHandle(
          response: userRes,
          context: context,
          onSuccess: () async {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).setUser(userRes.body);
            await prefs.setString(
                socketIdKey, jsonDecode(userRes.body)['socketId']);
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> changeUserPassword({
    required BuildContext context,
    required String newPassword,
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
        http.Response userRes = await http.put(
          Uri.parse('$uri/user/password'),
          headers: <String, String>{
            'Content-type': "application/json; charset=UTF-8",
            'x-auth-token': token
          },
          body: jsonEncode(
            {
              'newPassword': newPassword,
            },
          ),
        );
        httpErrorHandle(
          response: userRes,
          context: context,
          onSuccess: () async {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).setUser(userRes.body);
            await prefs.setString(
              socketIdKey,
              jsonDecode(userRes.body)['socketId'],
            );
            await prefs.setString(tokenKey, jsonDecode(userRes.body)['token']);
            showSnackBar(
              context,
              "Password updated Successfully!\nPlease use your new password to signin later.",
            );
          },
        );
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
