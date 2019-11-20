import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/member.dart';
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
        if (
            (state as Posts).refresh == 0 ||
            (state as Posts).ident != args.ident ||
            (state as Posts).community != args.community
        ) {
          _bloc.dispatch(
            FetchPosts(
              ident: args.ident,
              community: args.community,
              refresh: true
            )
          );
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: CtClose(),
            border: null,
            middle: (state as Posts).req? CupertinoActivityIndicator(): Text(''),
          ),
          child: BlocBuilder<MemberBloc, MemberState>(
            builder: (mContext, mState) {
              String name;
              String mail;
              String avatar;
              List<dynamic> posts = (state as Posts).posts;
              List<dynamic> members = (mState as Members).members;
              if ((mState as Members).refresh < 1) {
                return PostList(loading: true);
              }

              for (var m in members) {
                if(m['mail'] == (state as Posts).ident) {
                  name = m['name'];
                  avatar = m['avatar'];
                }
              }

              for (var p in posts) {
                p['author'] = name;
                p.putIfAbsent('mail', () => args.ident);
                p.putIfAbsent('avatar', () => avatar);
              }

              return PostList(
                posts: posts,
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
