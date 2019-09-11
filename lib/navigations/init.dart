import 'package:flutter/material.dart';
import 'package:cdr_today/pages/mine.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/navigations/args.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer()
          )
        ),
        centerTitle: true,
        title: Text('文章列表'),
        automaticallyImplyLeading: false
      ),
      body: Post(),
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
        alignment: AlignmentDirectional.centerEnd,
        constraints: BoxConstraints(maxHeight: 42.0),
        decoration: BoxDecoration(color: Colors.grey[200])
      ),
      drawer: Drawer(child: Mine())
    );
  }
}
