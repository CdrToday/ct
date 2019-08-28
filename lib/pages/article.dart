import 'package:flutter/material.dart';
import 'package:cdr_today/navigations/args.dart';

class Article extends StatelessWidget {
  final ArticleArgs args;
  Article({ this.args });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文章详情')),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              args.title,
              style: TextStyle(
                height: 2.0,
                fontSize: 20.0,
                fontWeight: FontWeight.w500
              )
            ),
            Divider(),
            Container(
              child: Text(
                args.content,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)
              ),
              padding: EdgeInsets.only(top: 15.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start
        ),
        padding: EdgeInsets.only(right: 20.0, left: 20.0)
      )
    );
  }
}
