import 'package:flutter/material.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/navigations/args.dart';

class Article extends StatelessWidget {
  final ArticleArgs args;
  Article({ this.args });

  Widget image() {
    if (args.cover.length > 0) {
      String url = conf['image'] + args.cover;
      return Center(child: Image.network(url));
    }
    return SizedBox.shrink();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: CloseButton()
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Text(
              args.title,
              style: TextStyle(height: 1.5, fontSize: 26.0, fontWeight: FontWeight.w700)
            ),
            padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 12.0),
          ),
          image(),
          Container(
            child: Text(args.content, style: TextStyle(fontSize: 16.0)),
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
          ),
          Container(
            child: Text(
              display(args.timestamp),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              )
            ),
            padding: EdgeInsets.only(
              bottom: kToolbarHeight / 2,
              right: kToolbarHeight / 2,
              top: kToolbarHeight,
            ),
            alignment:  AlignmentDirectional.bottomEnd
          )
        ],
      ),
    );
  }
}
