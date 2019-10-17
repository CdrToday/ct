import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/widgets/post.dart';

class Post extends StatefulWidget {
  final CupertinoSliverNavigationBar appBar;
  final SliverList title;
  Post({ this.appBar, this.title });
  
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is Posts) {
          return PostList(
            posts: state.posts,
            appBar: widget.appBar,
            title: widget.title,
            hasReachedMax: state.hasReachedMax,
          );
        }
        return PostList(
          appBar: widget.appBar,
          title: widget.title,
          loading: true,
        );
      }
    );
  }
}
