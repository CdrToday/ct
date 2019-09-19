import 'package:flutter/material.dart';

class CommunityTile extends StatelessWidget {
  final Widget avatar;
  final Widget name;
  final Widget trailing;
  final VoidCallback onTap;
  final EdgeInsets padding;

  CommunityTile({ this.avatar, this.name, this.trailing, this.onTap, this.padding });
  
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Row(
          children: [
            avatar ?? SizedBox.shrink(),
            SizedBox(width: 10.0),
            name ?? SizedBox.shrink(),
            Spacer(),
            trailing ?? SizedBox.shrink(),
          ]
        ),
        onTap: onTap
      ),
      padding: padding
    );
  }
}
