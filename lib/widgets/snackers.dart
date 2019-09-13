import 'package:flutter/material.dart';

void snacker(
  BuildContext context, String text, { Color color }
) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color == null ? Colors.grey : color,
      content: Text(text),
      duration: Duration(seconds: 1)
    ),
  );
}
