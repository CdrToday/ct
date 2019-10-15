// @salute to reddit
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/widgets/_actions/edit.dart';

class RedditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: RedditRefresher(
          widget: CommunityName(qr: true)
        ),
        trailing: EditAction(context),
      ),
      child: Reddit(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class Reddit extends StatefulWidget {
  final CupertinoSliverNavigationBar appBar;
  final SliverList title;
  Reddit({ this.appBar, this.title });
  
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
                  r['author'] = m['name'];
                  r.putIfAbsent('mail', () => m['mail']);
                  r.putIfAbsent('avatar', () => m['avatar']);
                }
              }
            }

            // return Container();
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
