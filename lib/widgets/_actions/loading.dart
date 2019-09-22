import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  final double size;
  final double space;
  Loading({ this.size, this.space });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: space ?? 16.0),
      child: CupertinoActivityIndicator(),
    );
  }
}
