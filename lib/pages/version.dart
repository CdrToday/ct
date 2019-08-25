import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('版本信息')),
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
            Text('version 0.1.0', style: TextStyle(color: Colors.grey)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        padding: EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          bottom: 100.0
        )
      ),
    );
  }
}
