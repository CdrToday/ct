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
                fontSize: 20.0,
                fontWeight: FontWeight.w400
              )
            ),
            Divider(),
            Container(
              child: Text(
                args.content,
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)
              ),
              padding: EdgeInsets.only(top: 10.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start
        ),
        padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0, bottom: 20.0),
      )
    );
  }
}
