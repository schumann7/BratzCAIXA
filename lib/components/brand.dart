import 'package:flutter/material.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.0,
      ),
    );
  }
}