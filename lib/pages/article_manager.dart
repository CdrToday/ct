import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/article_list.dart';
import 'package:cdr_today/pages/article_list.dart';
import 'package:cdr_today/navigations/args.dart';

class ArticleManager extends StatelessWidget {
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文章管理'),
        leading: CloseButton()
      ),
      body: ArticleList(edit: true)
    );
  }  
}
