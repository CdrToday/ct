import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/pages/mine.dart';
import 'package:cdr_today/pages/article_list.dart';
import 'package:cdr_today/navigations/args.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        centerTitle: true,
        bottomOpacity: 100.0,
        title: Text('文章列表'),
        automaticallyImplyLeading: false
      ),
      body: ArticleList(),
      bottomSheet: Container(
        child: IconButton(
          icon: Icon(Icons.mode_edit),
          onPressed: () {
            Navigator.pushNamed(
              context, '/user/edit',
              arguments: ArticleArgs(edit: false)
            );
          },
          color: Colors.black,
        ),
        padding: EdgeInsets.only(right: 10.0),
        alignment: AlignmentDirectional.centerEnd,
        constraints: BoxConstraints(
          maxHeight: 42.0
        ),
        decoration: BoxDecoration(color: Colors.grey[100])
      ),
      endDrawer: Drawer(child: Mine())
    );
  }
}
