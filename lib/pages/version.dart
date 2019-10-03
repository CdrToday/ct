import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cdr_today/widgets/buttons.dart';

class VersionPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: Close(),
      ),
      body: Container(
        child: Column(
          children: [
            Spacer(),
            GestureDetector(
              child: Text(
                'cdr.today',
                style: Theme.of(context).textTheme.display1,
                textAlign: TextAlign.center
              ),
              onTap: () async {
                var url = 'mailto:cdr.today@foxmail.com?subject=意见反馈';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              }
            ),
            Spacer(),
            Text(
              'version 0.2.16',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
        padding: EdgeInsets.only(bottom: kToolbarHeight)
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
