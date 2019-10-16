import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:screenshot/screenshot.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class Community extends StatelessWidget {
  final QrCodeArgs args;
  Community({ this.args });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                AvatarHero(self: true, rect: true, tag: 'no-tag'),
                SizedBox(width: 10.0),
                Name(self: true),
              ]
            ),
            QrImage(
              data: args.code,
              version: QrVersions.auto,
            ),
            AutoSizeText(
              '邀请你加入 ${args.name}',
              maxLines: 1,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround
        ),
        width: MediaQuery.of(context).size.width - 80.0,
        height: MediaQuery.of(context).size.height * 3 / 5,
        padding: EdgeInsets.all(20.0),
      ),
    );
  }

  static Widget action({
      BuildContext context, ScreenshotController controller
  }) {
    Widget more = CtNoRipple(
      icon: Icons.more_horiz,
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('分享'),
                onPressed: () async {
                  Navigator.pop(context);
                  File image = await controller.capture(pixelRatio: 1.5);
                  String name = DateTime.now().toString();
                  await Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
                }
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () => Navigator.pop(context),
            )
          )
        );
      },
    );

    return more;
  }
}
