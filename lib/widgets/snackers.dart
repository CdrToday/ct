import 'package:flutter/material.dart';

void snacker(
  BuildContext context, String text, { Color color }
) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color == null ? Colors.red : color,
      content: Text(text),
    ),
  );
}
