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
            Spacer(),
            Text(
              'cdr.today',
              style: Theme.of(context).textTheme.display2,
              textAlign: TextAlign.center
            ),
            Spacer(),
            Text(
              'version 0.1.11',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
        padding: EdgeInsets.only(bottom: kToolbarHeight)
      ),
    );
  }
}
