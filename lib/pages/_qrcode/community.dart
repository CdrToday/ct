import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/qrcode.dart' as qrw;

class QrCode extends StatelessWidget {
  final screenshotController = ScreenshotController();
  final QrCodeArgs args;
  QrCode({ this.args });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        backgroundColor: Colors.grey[200],
        actions: qrw.Community.actions(
          context: context,
          controller: screenshotController,
        )
      ),
      body: Container(
        child: Screenshot(
          child: qrw.Community(args: args),
          controller: screenshotController,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: kToolbarHeight),
      ),
      backgroundColor: Colors.grey[200]
    );
  }
}
