import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';

class Input extends StatelessWidget {
  final void Function(String) onChanged;
  final String helper;
  final String placeholder;
  final double size;
  final TextInputType type;
  final TextEditingController controller;
  final bool center;
  
  Input({
      this.onChanged,
      this.helper,
      this.placeholder,
      this.type,
      this.size,
      this.controller,
      this.center = true
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CupertinoTextField(
            autofocus: true,
            onChanged: onChanged,
            style: TextStyle(fontSize: size ?? 18.0),
            decoration: BoxDecoration(border: null),
            placeholder: placeholder,
            keyboardType: type ?? null,
            controller: controller ?? null,
          ),
          color: CtColors.gray6,
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Text(helper ?? ''),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          alignment: Alignment.centerLeft
        )
      ],
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
    );
  }
}

