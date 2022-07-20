import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: "",
    username: "",
    email: "",
    token: "",
    password: "",
    friends: [""],
    isOnline: false,
    createdAt: "",
    updatedAt: "",
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
