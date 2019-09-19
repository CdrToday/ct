import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cdr_today/widgets/avatar.dart';

class MainDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header(context),
        // version(context),
        Spacer()
      ],
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return DrawerHeader(
    child: Center(
      child: AvatarHero(
        tag: 'mine',
        width: 28.0,
        onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket'),
      )
    ),
  );
}
