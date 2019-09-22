import 'dart:io';
import 'package:flutter/material.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

// article actions
List<Widget> articleActions(BuildContext context, screenshotController) {
  Builder more = Builder(
    builder: (ctx) => IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () async {
        File image = await screenshotController.capture(pixelRatio: 1.5);
        String name = DateTime.now().toString();

        await Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
      }
    )
  );

  return [more];
}
