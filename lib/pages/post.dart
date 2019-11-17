import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/rng.dart';

class PostPage extends StatelessWidget {
  final PostArgs args;
  PostPage({ this.args });
  
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<PostBloc>(context);
    
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if ((state as Posts).refresh == 0) {
          _bloc.dispatch(FetchPosts(ident: args.ident, refresh: true));
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CtClose(),
            border: null,
            middle: (state as Posts).req? CupertinoActivityIndicator(): Text('文章'),
          ),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (uContext, uState) {
              String name = (uState as UserInited).name;
              String mail = (uState as UserInited).mail;
              List<dynamic> posts = (state as Posts).posts;

              if (name == '') name = rngName();
              for (var p in posts) {
                p['author'] = name;
                p.putIfAbsent('mail', () => mail);
              }
              
              return PostList(
                // appBar: widget.appBar,
                // title: widget.title,
                posts: (state as Posts).posts,
                community: false,
                hasReachedMax: (state as Posts).hasReachedMax,
              );
            }
          ),
        );
      }
    );
  }
}
