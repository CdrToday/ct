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
          } else if (state is FetchedSucceed) {
            if (state.posts.isEmpty) {
              return CenterX(x: '暂无文章');
            }
            return PostList(
              posts: state.posts, edit: widget.edit,
              hasReachedMax: state.hasReachedMax,
            );
          } 
          return CenterX();
        }
      )
    );
  }
}
