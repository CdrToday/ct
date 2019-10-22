import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/x/_style/text.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/x/conf.dart';

class VersionPage extends StatelessWidget {
  Widget build(context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        border: null,
        backgroundColor: CtColors.tp
      ),
      child: Container(
        child: Column(
          children: [
            Spacer(),
            Text(
              conf['name'],
              style: CtTextStyle.largeTitle,
              textAlign: TextAlign.center
            ),
            Spacer(),
            Text(
              conf['version'],
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
