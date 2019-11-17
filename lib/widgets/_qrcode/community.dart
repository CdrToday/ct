import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:screenshot/screenshot.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:cdr_today/x/permission.dart' as pms;

class Community extends StatelessWidget {
  final QrCodeArgs args;
  Community({ this.args });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> _args = {
      'code': args.code,
      'name': args.name
    };

    final String code = jsonEncode(_args);
    final double _width = MediaQuery.of(context).size.width;
    double _cw;

    if (_width > 600) {
      _cw = _width *  1 / 2;
    } else if (_width > 375) {
      _cw = _width * 3 / 5;
    } else {
      _cw = _width * 2 / 3;
    }
    
    return Card(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                AvatarHero(
                  self: true,
                  rect: true,
                  tag: 'no-tag',
                  width: _cw / 14,
                ),
                SizedBox(width: 10.0),
                Name(self: true, size: _cw / 20),
              ]
            ),
            Container(
              child: QrImage(
                data: code,
                version: QrVersions.auto,
              ),
              padding: EdgeInsets.all(_cw / 28)
            ),
            AutoSizeText(
              '邀请你加入 "${args.name}"',
              maxLines: 1,
              style: TextStyle(fontSize: _cw / 25)
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround
        ),
        width: _cw,
        height: _cw * 5 / 4,
        margin: EdgeInsets.all(_cw / 15),
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
                  if (await pms.checkPhotos(context) == false) return;
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
