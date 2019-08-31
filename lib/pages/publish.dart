import 'package:flutter/material.dart';

class Publish extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      children: <Widget>[
        line(context, '文章', '可以发表长段文字', '/user/edit', Icons.note_add)
      ]
    );
  }
}

Widget line(BuildContext context, String title, String info, String route, IconData icon) {
  return Card(
    child: ListTile(
      leading: Icon(icon, size: 42.0),
      title: Text(title),
      subtitle: Text(info),
      onTap: () {
        Navigator.pushNamed(context, route);
      }
    )
  );
}
