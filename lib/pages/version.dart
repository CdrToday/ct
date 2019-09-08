import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('版本信息'),
        leading: CloseButton()
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Text(
                'cdr.today',
                style: Theme.of(context).textTheme.display1
              )
            ),
            Divider(),
            Text('version 0.1.5', style: TextStyle(color: Colors.grey)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        padding: EdgeInsets.only(left: 80.0, right: 80.0),
        transform: Matrix4.translationValues(0.0, -80.0, 0.0),
      ),
    );
  }
}
