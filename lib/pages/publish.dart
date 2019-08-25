import 'package:flutter/material.dart';

class Publish extends StatelessWidget {
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      children: <Widget>[
        line(context)
      ]
    );
  }
}

Widget line(BuildContext context) {
  return Card(
    child: ListTile(
      leading: Icon(Icons.note_add, size: 42.0),
      title: Text('文章'),
      subtitle: Text('可以发表长段文字'),
      onTap: () {
        Navigator.pushNamed(context, '/user/edit');
      }
    )
  );
}
