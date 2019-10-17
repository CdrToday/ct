import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/actions.dart' as actions;

class Avatar extends StatelessWidget {
  final screenshotController = ScreenshotController();
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: ProfileRefresher(
          widget: actions.Avatar(
            screenshotController: screenshotController
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: CtClose(color: Colors.white),
        border: null,
      ),
      child: Builder(
        builder: (context) => Center(
          child: Screenshot(
            child: Container(
              child: AvatarHero(
                self: true,
                rect: true,
                width: MediaQuery.of(context).size.width / 2,
              ),
              color: Colors.black,
            ),
            controller: screenshotController,
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
