import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';

class Input extends StatelessWidget {
  final void Function(String) onChanged;
  final String helper;
  final String placeholder;
  
  Input({ this.onChanged, this.helper, this.placeholder });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CupertinoTextField(
            autofocus: true,
            onChanged: onChanged,
            style: TextStyle(fontSize: 18.0),
            decoration: BoxDecoration(border: null),
            placeholder: placeholder,
          ),
          color: CtColors.gray6,
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Text(helper),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          alignment: Alignment.centerLeft
        )
      ]
    );
  }
}

