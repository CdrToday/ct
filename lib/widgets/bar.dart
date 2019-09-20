import 'package:flutter/material.dart';

class DrawerBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback action;

  DrawerBar({ this.icon, this.title, this.action });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          decoration: new BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[200], Colors.grey[50]]
            ),
          ),
          height: 32.0,
          width: MediaQuery.of(context).size.width * 2 / 3,
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          alignment: Alignment.centerLeft,
        ),
        icon != null ? SizedBox(
          child: IconButton(
            icon: Icon(
              icon ?? Icons.add_circle_outline,
              size: 20.0,
            ),
            color: Colors.grey[600],
            onPressed: action ?? null,
          ),
          height: 32.0,
        ) : SizedBox.shrink()
      ]
    );
  }
}
