import 'package:flutter/material.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/widgets/avatar.dart';

class WeChat extends StatelessWidget {
  final String cover;
  final String avatar;
  final String author;
  final String title;
  final int timestamp;
  final VoidCallback onTap;

  WeChat({
      this.cover,
      this.avatar,
      this.author = '?',
      this.title = '',
      this.timestamp = 0,
      this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Card(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                head(avatar: avatar, author: author, timestamp: timestamp),
                cover != null ? Center(
                  child: Image.network(
                    conf['image'] + cover,
                    height: 180.0,
                    fit: BoxFit.fitWidth,
                    width: double.infinity,
                  )
                ): SizedBox.shrink(),
                content(title: title),
              ]
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0)
            ),
          ),
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))
          ),
        ),
        margin: EdgeInsets.all(6.0),
      ),
      onTap: onTap,
    );
  }
}

Widget head({String avatar, String author, int timestamp}) {
  return Container(
    child: Row(
      children: [
        Avatar(
          url: avatar,
          baks: [author],
          width: 12.0
        ),
        SizedBox(width: 10.0),
        Text(author, style: TextStyle(fontSize: 14.0)),
        Spacer(),
        Text(
          display(timestamp),
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          )
        )
      ]
    ),
    padding: EdgeInsets.only(
      left: 12.0, right: 12.0, top: 12.0, bottom: 12.0
    ),
  );
}

Widget content({String title}) {
  if (title == null) {
    return Container();
  }
  return Container(
    child: Column(
      children: [
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
            ),
            textAlign: TextAlign.left,
          ),
          alignment: Alignment.centerLeft
        ),
      ],
    ),
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.only(
      left: 20.0, right: 20.0, top: 12.0, bottom: 20.0,
    ),
  );
}
