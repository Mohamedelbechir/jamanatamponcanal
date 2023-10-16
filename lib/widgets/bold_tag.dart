import 'package:flutter/material.dart';

class BoldTag extends StatelessWidget {
  final MaterialColor color;
  final String text;
  const BoldTag({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: color[50],
        borderRadius: const BorderRadius.all(
          Radius.circular(3),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color[700],
        ),
      ),
    );
  }
}
