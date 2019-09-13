import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/navigations/args.dart';

class Article extends StatelessWidget {
  final ArticleArgs args;
  Article({ this.args });

  @override
  Widget build(BuildContext context) {
    var focusNode = FocusNode();
    var controller = ZefyrController(NotusDocument.fromJson(jsonDecode(args.document)));
    
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: CloseButton()
      ),
      body: Editor(
        controller: controller,
        focusNode: focusNode,
        edit: false
      )
    );
  }
}
