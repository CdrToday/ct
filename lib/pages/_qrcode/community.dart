import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/qrcode.dart' as qrw;

class QrCode extends StatelessWidget {
  final screenshotController = ScreenshotController();
  final QrCodeArgs args;
  QrCode({ this.args });
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        trailing: qrw.Community.action(
          context: context,
          controller: screenshotController,
        ),
        border: null
      ),
      child: Container(
        child: Screenshot(
          child: qrw.Community(args: args),
          controller: screenshotController,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: kToolbarHeight),
      ),
    );
  }
}
