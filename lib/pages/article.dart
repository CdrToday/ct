import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/widgets/actions.dart';
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
    focusNode = FocusNode();
    controller = ZefyrController(NotusDocument.fromJson(jsonDecode(widget.args.document)));
    screenshotController = ScreenshotController();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: CloseButton(),
        actions: editActionsProvider(
          context,
          args: widget.args,
          screenshotController: screenshotController,
          zefyrController: controller,
          toEdit: () {
            Navigator.pop(context);
            setState(() { _edit = true; });
          },
          toPreview: () {
            setState(() { _edit = false; });
          },
          edit: _edit,
          update: true,
        ),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          child: Editor(
            controller: controller,
            focusNode: focusNode,
            edit: _edit,
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
