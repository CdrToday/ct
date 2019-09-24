import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/actions.dart' as actions;

class Avatar extends StatelessWidget {
  final screenshotController = ScreenshotController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        actions: [
          ProfileRefresher(
            widget: actions.Avatar(
              screenshotController: screenshotController
            )
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: Builder(
        builder: (context) => Center(
          child: Screenshot(
            child: Container(
              child: AvatarHero(self: true, rect: true),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: kToolbarHeight * 1.5 )
            ),
            controller: screenshotController,
          )
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class CustomAvatar extends StatelessWidget {
  final CustomAvatarArgs args;
  CustomAvatar({ this.args });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            child: AvatarHero(
              url: args.url,
              tag: args.url,
              baks: args.baks,
              rect: args.rect,
              width: MediaQuery.of(context).size.width
            ),
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(bottom: kToolbarHeight * 1.5 )
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
