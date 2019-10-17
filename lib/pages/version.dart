import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/x/_style/text.dart';

class VersionPage extends StatelessWidget {
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        border: null,
        backgroundColor: Colors.transparent
      ),
      child: Container(
        child: Column(
          children: [
            Spacer(),
            Text(
              'cdr.today',
              style: CtTextStyle.largeTitle,
              textAlign: TextAlign.center
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
    );
  }
}
