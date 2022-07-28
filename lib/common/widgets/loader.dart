import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color color;
  const Loader({
    Key? key,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
