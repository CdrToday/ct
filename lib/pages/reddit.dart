// @salute to reddit
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/_actions/edit.dart';

class RedditPage extends StatelessWidget {
  final bool self;
  RedditPage({ this.self = false });
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: self? SizedBox.shrink() :RedditRefresher(
          widget: CommunityName(qr: true)
        ),
        leading: self? CtClose() : CtNoRipple(
          size: 22.0,
          icon: Icons.inbox,
          onTap: () => Navigator.of(
            context, rootNavigator: true
          ).pushNamed('/community/topics')
        ),
        trailing: self? SizedBox.shrink() : EditAction(context),
        border: null
      ),
      child: Reddit(self: self),
      resizeToAvoidBottomInset: false,
    );
  }
}

class Reddit extends StatefulWidget {
  final CupertinoSliverNavigationBar appBar;
  final SliverList title;
  final bool self;
  Reddit({ this.appBar, this.title, this.self });
  
  @override
  _RedditState createState() => _RedditState();
}

class _RedditState extends State<Reddit> {
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, mstate) {
        List<dynamic> members = (mstate as Members).members;
        if ((mstate as Members).refresh < 1) {
          return PostList(
            appBar: widget.appBar,
            title: widget.title,
            loading: true,
          );
        }
        
        return BlocBuilder<RedditBloc, RedditState>(
          builder: (context, state) {
            List<dynamic> reddits = (state as Reddits).reddits;
            // map members' info into reddits.
            for (var r in reddits) {
              for (var m in members) {
                if (m['mail'] == r['author']) {
                  r['author'] = m['name'] == '' ? '' : m['name'];
                  r.putIfAbsent('mail', () => m['mail']);
                  r.putIfAbsent('avatar', () => m['avatar']);
                }
              }

              if (
                RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(r['author'])
              ) {
                r['author'] = '';
              }
            }
            
            return PostList(
              appBar: widget.appBar,
              title: widget.title,
              posts: reddits,
              community: true,
              hasReachedMax: (state as Reddits).hasReachedMax,
            );
          }
        );
      }
    );
  }
}
