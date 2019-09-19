import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/community.dart';

class MainDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add_circle_outline),
        //     color: Colors.black,
        //     onPressed: () => Navigator.pushNamed(context, '/scan')
        //   )
        // ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: <Widget>[
          header(context),
          Row(
            children: [
              Container(
                child: Text(
                  '我的社区',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[200], Colors.grey[50]]
                  ),
                ),
                height: 36.0,
                width: MediaQuery.of(context).size.width * 2 / 3,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                alignment: Alignment.centerLeft,
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                color: Colors.grey[600],
                onPressed: () => Navigator.pushNamed(context, '/scan')
              ),
            ]
          ),
          SizedBox(height: kToolbarHeight * 2)
        ],
      )
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 10.0),
      AvatarHero(
        self: true, width: 30.0,
        onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket'),
      ),
      SizedBox(height: 15.0),
      Name(self: true, size: 18.0),
      SizedBox(height: 30.0),
    ]
  );
}
