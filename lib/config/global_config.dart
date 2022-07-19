import 'package:flutter/material.dart';

class GlobalConfig {
  // static const Color backgroundColor = Color(0xffa2d2ff);
  static const Color backgroundColor = Color(0xffffffff);
  // static const Color secondaryBackgroundColor = Color(0xffbde0fe);
  static const Color secondaryBackgroundColor = Color(0xffffffff);
  // static const Color secondaryColor = Color(0xff8d99ae);
  static const Color secondaryColor = Color(0xffffffff);
  static const Color darkerBackgroundColor = Color(0xff749eff);
  static const Color primaryBackgroundColor = Color(0xff82baff);
  static const appBarGradient = LinearGradient(
    colors: [primaryBackgroundColor, darkerBackgroundColor],
    stops: [0.5, 1.0],
  );
}
