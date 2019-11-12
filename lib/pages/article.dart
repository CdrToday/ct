import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/_actions/edit.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Article extends StatefulWidget {
  final ArticleArgs args;
  Article({ this.args });
  
  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  bool _edit = false;
  bool _flag = false;
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
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if ((state as UserInited).mail == widget.args.mail) _flag = true;

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CtClose(),
            border: null,
            trailing: _flag == false? null : (
              _edit == false ? More(
                update: true,
                args: widget.args,
                zefyrController: controller,
                toEdit: () {
                  setState(() { _edit = true; });
                  Navigator.pop(context);
                },
                screenshotController: screenshotController,
                sContext: context,
              ) : Post(
                update: true,
                args: widget.args,
                zefyrController: controller,
                toPreview: () {
                  setState(() { _edit = false; });
                },
              )
            )
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
          )
        );
      }
    );
  }
}
