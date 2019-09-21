import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/_author.dart';
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
          return PostList(
            appBar: widget.appBar,
            title: widget.title,
            loading: true,
          );
        } else if (state is FetchedSucceed) {
          return PostList(
            posts: state.posts,
            edit: widget.edit,
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
  Widget build(BuildContext context) {
    final AuthorPostBloc _bloc = BlocProvider.of<AuthorPostBloc>(context);
    return BlocBuilder<AuthorPostBloc, AuthorPostState>(
      builder: (context, state) {
        if (state is AuthorPostsUnFetched) {
          _bloc.dispatch(FetchAuthorPosts(mail: widget.mail));
          return PostList(
            appBar: widget.appBar,
            title: widget.title,
            loading: true,
          );
        } else if (state is AuthorPosts) {
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
