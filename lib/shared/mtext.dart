import 'package:flutter/material.dart';

class MText extends StatelessWidget {
  final String content;
  final double size;
  final bool bold;
  final bool italic;
  const MText(
      {super.key,
      required this.content,
      required this.size,
      required this.bold,
      required this.italic});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }
}
