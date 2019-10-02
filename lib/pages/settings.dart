import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Close(),
      ),
      body: Column(
        children: [
          BasicTile(
            text: '服务条款',
            onTap: () async {
              var url = 'https://cdr-today.github.io/intro/privacy/zh.html';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          BasicTile(
            text: '联系作者',
            onTap: () async {
              var url = 'mailto:cdr.today@foxmail.com?subject=hello';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          BasicTile(
            text: '版本信息',
            onTap: () => Navigator.popAndPushNamed(context, '/mine/version')
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
