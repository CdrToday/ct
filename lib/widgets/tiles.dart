import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Tile extends StatelessWidget {
  final Widget title; 
  final Widget trailing;
  final VoidCallback onTap;
  final EdgeInsets margin;

  Tile({
      this.title,
      this.trailing,
      this.onTap,
      this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: title,
          trailing: trailing,
          onTap: onTap,
        )
      ),
      margin: margin ?? EdgeInsets.only(top: 10.0)
    );
  }
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
