import 'package:flutter/material.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/widgets/avatar.dart';

class WeChat extends StatelessWidget {
  final Avatar avatar;
  final String author;
  final String cover;
  final String title;
  final int timestamp;
  final VoidCallback onTap;

  WeChat({
      this.avatar,
      this.author = '?',
      this.cover,
      this.title,
      this.timestamp = 0,
      this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            head(avatar: avatar, author: author),
            content(title: title),
          ]
        ),
        elevation: 0.2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        )
      ),
      padding: EdgeInsets.all(6.0),
    );
  }
}

Widget head({Avatar avatar, String author}) {
  return Container(
    child: Row(
      children: [
        avatar ?? Avatar(
          baks: [author],
          width: 14.0
        ),
        SizedBox(width: 10.0),
        Text(author, style: TextStyle(fontSize: 16.0)),
      ]
    ),
    padding: EdgeInsets.only(
      left: 12.0, right: 12.0, top: 12.0, bottom: 12.0
    ),
  );
}

Widget content({String title}) {
  return Container(
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18.0
      ),
    ),
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(
      left: 20.0, right: 20.0, top: 12.0, bottom: 12.0
    ),
  );
}
