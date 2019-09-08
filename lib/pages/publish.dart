import 'package:flutter/material.dart';
import 'package:cdr_today/navigations/args.dart';

class Publish extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      children: <Widget>[
        line(
          context,
          title: '文章',
          info: '可以发表长段文字',
          route: '/user/edit',
          icon: Icons.gesture,
          args: ArticleArgs(edit: false)
        )
      ]
    );
  }
}

Widget line(BuildContext context, {
    String title, String info, String route, IconData icon, dynamic args
}) {
  return Card(
    child: ListTile(
      leading: Icon(icon, size: 42.0),
      title: Text(title),
      subtitle: Text(info),
      onTap: () {
        Navigator.pushNamed(context, route, arguments: args);
      }
    )
  );
}
