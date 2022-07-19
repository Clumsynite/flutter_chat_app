import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/error_handling.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:http/http.dart' as http;

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
      if (res.statusCode == 200) {
        onSuccess();
      } else {
        onError();
      }
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            "Account created successfully!\nLogin with these credentials",
          );
        },
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
    required VoidCallback onSuccess,
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
      if (res.statusCode == 200) {
        onSuccess();
      } else {
        onError();
      }
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      onError();
      showSnackBar(context, e.toString());
    }
  }
}
