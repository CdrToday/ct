import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/_author.dart';
import 'package:cdr_today/widgets/post.dart';

class Post extends StatefulWidget {
  final SliverAppBar appBar;
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

class AuthorPostContainer extends StatefulWidget {
  final SliverAppBar appBar;
  final SliverList title;
  final String mail;
  AuthorPostContainer({ this.appBar, this.title, this.mail });
  
  @override
  _AuthorPostContainerState createState() =>_AuthorPostContainerState();
}

class _AuthorPostContainerState extends State<AuthorPostContainer> {

  @override
  initState() {
    super.initState();
    final AuthorPostBloc _bloc = BlocProvider.of<AuthorPostBloc>(context);
    _bloc.dispatch(FetchAuthorPosts(refresh: true, mail: widget.mail));
  }
  
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorPostBloc, AuthorPostState>(
      builder: (context, state) {
        if (state is AuthorPosts) {
          return PostList(
            mail: widget.mail,
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
