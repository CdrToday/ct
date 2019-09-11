import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/widgets/center.dart';
import 'package:cdr_today/navigations/args.dart';

class Post extends StatefulWidget {
  final bool edit;
  Post({ this.edit });
  
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Widget build(BuildContext context) {
    final PostBloc _bloc = BlocProvider.of<PostBloc>(context);
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is FetchedFailed) {
          _bloc.dispatch(FetchSelfPosts());
        }
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is UnFetched) {
            _bloc.dispatch(FetchSelfPosts());
            return CenterX();
          } else if (state is EmptyList) {
            return CenterX(x: '暂无文章');
          } else if (state is FetchedSucceed) {
            return _buildList(context, state.posts, widget.edit);
          } 
          return CenterX();
        }
      )
    );
  }
}

Widget _buildList(BuildContext context, List<dynamic> posts, bool edit) {
  return ListView.separated(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 52.0),
    itemCount: posts.length,
    itemBuilder: (BuildContext context, int index) {
      String id = posts[index]['id'];
      String title = posts[index]['title'];
      String cover = posts[index]['cover'];
      String content = posts[index]['content'];

      content = content.replaceAll('\n', ' ');
      if (content.length > 120) {
        content = content.substring(0, 112);
        content = content + '...';
      }

      return PostItem(
        x: ArticleArgs(id: id, title: title, cover: cover, content: content)
      );
    },
    separatorBuilder: (BuildContext context, int index) => const Divider(),
  );
}
