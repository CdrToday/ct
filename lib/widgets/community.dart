import 'package:flutter/material.dart';

class CommunityTile extends StatelessWidget {
  final Widget avatar;
  final Widget name;
  final Widget action;

  CommunityTile({ @required this.avatar, @required this.name, this.action });
  
  Widget build(BuildContext context) {
    return Row(
      children: [
        avatar,
        SizedBox(width: 10.0),
        name,
        Spacer(),
        action ?? SizedBox.shrink(),
      ]
    );
  }
}
