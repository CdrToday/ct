import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cdr_today/widgets/avatar.dart';

class Mine extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header(context),
        articles(context),
        // community(context),
        Divider(),
        author(context),
        version(context),
        Spacer()
      ],
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return DrawerHeader(
    child: Center(
      child: GestureDetector(
        child: avatar(),
        onTap: () => Navigator.popAndPushNamed(context, '/mine/profile'),
      ),
    ),
  );
}

Widget articles(BuildContext context) {
  return ListTile(
    title: Text(
      '文章管理',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket')
  );
}

Widget community(BuildContext context) {
  return ListTile(
    title: Text(
      '我的社区',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () async {
      var url = 'mailto:cdr.today@foxmail.com?subject=hello';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  );
}

Widget author(BuildContext context) {
  return ListTile(
    title: Text(
      '联系作者',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () async {
      var url = 'mailto:cdr.today@foxmail.com?subject=hello';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  );
}

Widget version(BuildContext context) {
  return  ListTile(
    title: Text(
      '版本信息',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/version')
  );
}
