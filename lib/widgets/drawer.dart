import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/name.dart';

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
                  '社区',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                decoration: new BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[200], Colors.grey[50]]
                  ),
                ),
                height: 32.0,
                width: MediaQuery.of(context).size.width * 2 / 3,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                alignment: Alignment.centerLeft,
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 20.0,
                ),
                color: Colors.grey[600],
                onPressed: () => Navigator.pushNamed(context, '/community/raise')
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
        onTap: () => Navigator.pushNamed(context, '/mine/bucket'),
      ),
      SizedBox(height: 15.0),
      Name(self: true, size: 18.0),
      SizedBox(height: 30.0),
    ]
  );
}
