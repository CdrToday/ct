import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/widgets/center.dart';

class Post extends StatefulWidget {
  final bool edit;
  final SliverAppBar appBar;
  final SliverList title;
  Post({ this.edit, this.appBar, this.title });
  
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Widget build(BuildContext context) {
    final PostBloc _bloc = BlocProvider.of<PostBloc>(context);
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is UnFetched) {
          return CenterX();
        } else if (state is FetchedSucceed) {
          if (state.posts.isEmpty) {
            return CenterX(x: '暂无文章');
          }
          return PostList(
            posts: state.posts,
            edit: widget.edit,
            appBar: widget.appBar,
            title: widget.title,
            hasReachedMax: state.hasReachedMax,
          );
        }
        return CenterX();
      }
    );
  }
}
