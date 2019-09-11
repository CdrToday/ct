import 'package:flutter/material.dart';

class Mine extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header(),
        profile(context),
        articles(context),
        version(context),
        Spacer()
      ],
    );
  }
}

// ----------- tiles -------------
Widget header() {
  return DrawerHeader(
    child: Center(child: Icon(Icons.gesture, color: Colors.black, size: 50.0))
  );
}

Widget profile(BuildContext context) {
  return  ListTile(
    title: Text('个人信息', textAlign: TextAlign.center),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/profile')
  );
}

Widget articles(BuildContext context) {
  return ListTile(
    title: Text('文章管理', textAlign: TextAlign.center),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket')
  );
}

Widget version(BuildContext context) {
  return  ListTile(
    title: Text('版本信息', textAlign: TextAlign.center),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/version')
  );
}
