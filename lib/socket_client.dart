import 'package:flutter/painting.dart';
import 'package:flutter_chat_app/config/env.dart';
import 'package:flutter_chat_app/config/global_config.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

// https://stackoverflow.com/a/71822566/13762501
class SocketClient {
  // A static private instance to access _socketApi from inside class only
  static final SocketClient _socketApi = SocketClient._internal();

  IO.Socket socket = IO.io(
    uri,
    IO.OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
        .setExtraHeaders({'foo': 'bar'}) // optional
        .build(),
  );

  Color randomColor = GlobalConfig().randomColour;

  // An internal private constructor to access it for only once for static instance of class.
  SocketClient._internal();

  // Factry constructor to retutn same static instance everytime you create any object.
  factory SocketClient() {
    return _socketApi;
  }

  void notifyUserOnline(String id) {
    socket.emit("client_online", id);
  }

  void notifyUserOffline(String id) {
    socket.emit("client_offline", id);
  }

  get on => socket.on;
}
