import 'package:flutter/material.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/x/rng.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WeChat extends StatelessWidget {
  final String cover;
  final String avatar;
  final String author;
  final String title;
  final String mail;
  final int timestamp;
  final VoidCallback onTap;

  WeChat({
      this.cover,
      this.avatar,
      this.mail,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              head(
                mail: mail,
                avatar: avatar,
                author: author,
                timestamp: timestamp
              ),
              // cover != null ? Center(
              //   child: Image.network(
              //     conf['image'] + cover,
              //     height: 180.0,
              //     fit: BoxFit.fitWidth,
              //     width: double.infinity,
              //   )
              // ): SizedBox.shrink(),
              content(context, title: title == null? '一张图片' : title),
            ]
          ),
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
          ),
          color: CtColors.gray6
        ),
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0
        )
      ),
      onTap: onTap,
    );
  }
}

Widget head({String avatar, String author, int timestamp, String mail}) {
  return Container(
    child: Row(
      children: [
        Avatar(
          url: avatar,
          baks: [author, rngName()],
          width: 12.0
        ),
        SizedBox(width: 10.0),
        Text(
          author != '' ? author: rngName(),
          style: TextStyle(
            fontSize: 14.0,
            color: CtColors.primary
          )
        ),
        Spacer(),
        Text(
          display(timestamp),
          style: TextStyle(
            fontSize: 12.0,
            color: CtColors.primary
          )
        )
      ]
    ),
    padding: EdgeInsets.symmetric(
      vertical: 6.0,
      horizontal: 12.0
    )
  );
}

Widget content(BuildContext context, {String title}) {
  if (title == null) return Container(height: 15.0);
  return Container(
    child: Column(
      children: [
        Container(
          child: AutoSizeText(
            title,
            style: TextStyle(
              fontSize: 16.0,
              color: CtColors.primary
            ),
            textAlign: TextAlign.left,
            maxLines: 1,
            overflow: TextOverflow.ellipsis
          ),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width - 60,
        ),
      ],
    ),
    alignment: Alignment.centerLeft,
    padding: EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0
    )
  );
}

