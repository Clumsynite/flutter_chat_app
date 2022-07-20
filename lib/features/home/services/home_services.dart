import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:flutter_chat_app/features/auth/screens/auth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
}
