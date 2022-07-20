import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String text;
  final double fontSize;
  const EmptyScreen({
    Key? key,
    required this.text,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
