import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/posts.dart';
import 'package:cdr_today/widgets/center.dart';
import 'package:cdr_today/navigations/args.dart';

class Posts extends StatefulWidget {
  final bool edit;
  Posts({ this.edit });
  
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Widget build(BuildContext context) {
    final PostsBloc _bloc = BlocProvider.of<PostsBloc>(context);
    return BlocListener<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is FetchedFailed) {
          _bloc.dispatch(FetchSelfArticles());
        }
      },
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is UnFetched) {
            _bloc.dispatch(FetchSelfArticles());
            return CenterX();
          } else if (state is EmptyList) {
            return CenterX(x: '暂无文章');
          } else if (state is FetchedSucceed) {
            return _buildList(context, state.list, widget.edit);
          } 
          return CenterX();
        }
      )
    );
  }
}

Widget _buildList(BuildContext context, List<dynamic> list, bool edit) {
  return ListView.separated(
    padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 52.0),
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      String title = list[index]['title'];
      String cover = list[index]['cover'];
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
          if (edit == true) {
            Navigator.pushNamed(
              context, '/user/edit',
              arguments: ArticleArgs(
                edit: edit,
                cover: cover,
                title: title,
                content: content,
                id: list[index]['id']
              )
            );
          } else {
            Navigator.pushNamed(
              context, '/article',
              arguments: ArticleArgs(
                edit: edit,
                cover: cover,
                title: title,
                content: content,
                id: list[index]['id']
              )
            );
          }
        }
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
