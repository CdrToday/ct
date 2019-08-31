import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/article_list.dart';
import 'package:cdr_today/pages/article_list.dart';
import 'package:cdr_today/navigations/args.dart';

class ArticleManager extends StatefulWidget {
  @override
  _ArticleManagerState createState() => _ArticleManagerState();
}

class _ArticleManagerState extends State<ArticleManager> {
  Widget build(BuildContext context) {
    final ArticleListBloc _bloc = BlocProvider.of<ArticleListBloc>(context);
    return BlocListener<ArticleListBloc, ArticleListState>(
      listener: (context, state) {

      },
      child: BlocBuilder<ArticleListBloc, ArticleListState>(
        builder: (context, state) {
          if (state is EmptyList) {
            return Center(child: Text('暂无文章'));
          } else if (state is UnFetched) {
            _bloc.dispatch(FetchSelfArticles());
            return Center(child: Text('正在请求中...'));
          } else if (state is FetchedSucceed) {
            return _builder(context);
          } else if (state is FetchedFailed) {
            return Center(child: Text('请求失败 🧐'));
          }
        }
      )
    );
  }
}

Widget _builder(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('文章管理')),
    body: Container(
      child: ArticleList(edit: true)
    )
  );
}
