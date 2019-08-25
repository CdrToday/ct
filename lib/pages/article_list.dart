import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/article_list.dart';
import 'package:cdr_today/navigations/args.dart';

class ArticleList extends StatefulWidget {
  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
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
            return _buildList(context, state.list);
          }
        }
      )
    );
  }
}

Widget _buildList(BuildContext context, List<dynamic> list) {
  return ListView.separated(
    padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      String title = list[index]['title'];
      String content = list[index]['content'];
      content = content.replaceAll('\n', ' ');
      if (content.length > 120) {
        content = content.substring(0, 112);
        content = content + '...';
      }
      
      return GestureDetector(
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400
            )
          ),
          subtitle: Container(
            child: Text(
              content,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)
            ),
            padding: EdgeInsets.only(top: 10.0),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(
            context, '/article',
            arguments: ArticleArgs(
              title: title,
              content: content,
              id: list[index]['_id']
            )
          );
        }
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
