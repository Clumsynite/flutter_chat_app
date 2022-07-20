// ignore_for_file: file_names
import 'package:flutter/material.dart';

class TextOutlined extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final double fontSize;

  const TextOutlined({
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/a/53211151/13762501
    return Text(
      text,
      style: TextStyle(
        inherit: true,
        fontSize: fontSize,
        color: color,
        shadows: [
          Shadow(
            // bottomLeft
            offset: const Offset(-1.5, -1.5),
            color: borderColor,
          ),
          Shadow(
            // bottomRight
            offset: const Offset(1.5, -1.5),
            color: borderColor,
          ),
          Shadow(
            // topRight
            offset: const Offset(1.5, 1.5),
            color: borderColor,
          ),
          Shadow(
            // topLeft
            offset: const Offset(-1.5, 1.5),
            color: borderColor,
          ),
        ],
      ),
    );
  }
}
