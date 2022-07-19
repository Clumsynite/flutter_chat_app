import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_chat_app/constants/utils.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
  VoidCallback? onError,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      if (onError != null) onError();
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      if (onError != null) onError();
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
