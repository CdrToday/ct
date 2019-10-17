import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/navigations/args.dart';

class Article extends StatefulWidget {
  final ArticleArgs args;
  Article({ this.args });
  
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  bool _edit = false;
  ZefyrController controller;
  ScreenshotController screenshotController;
  FocusNode focusNode;

  @override
  initState() {
    super.initState();
    focusNode = FocusNode();
    controller = ZefyrController(NotusDocument.fromJson(jsonDecode(widget.args.document)));
    screenshotController = ScreenshotController();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        border: null,
      ),
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          child: Editor(
            controller: controller,
            focusNode: focusNode,
            edit: _edit,
          ),
        ),
      ),
    );
  }
}
