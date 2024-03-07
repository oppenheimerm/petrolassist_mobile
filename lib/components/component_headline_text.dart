import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String title;
  final Color? colour;

  const Headline({
    super.key,
    required this.title,
    required this.colour
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: colour!,
      ),
    );
  }
}
