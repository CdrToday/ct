import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/widgets/actions.dart';
import 'package:cdr_today/widgets/refresh.dart';
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
    EditActionsProvider eap = EditActionsProvider(
      context,
      args: widget.args,
      screenshotController: screenshotController,
      zefyrController: controller,
      toEdit: () {
        Navigator.pop(context);
        setState(() { _edit = true; });
      },
      toPreview: () => setState(() { _edit = false; }),
      update: true,
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: CloseButton(),
        actions: _edit ? [
          EditRefresher(widget: eap.cancel, empty: true),
          EditRefresher(widget: eap.post),
        ] : [
          EditRefresher(widget: eap.more)
        ],
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
