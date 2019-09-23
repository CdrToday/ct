// @salute to reddit
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/member.dart';

class Reddit extends StatefulWidget {
  final bool edit;
  final SliverAppBar appBar;
  final SliverList title;
  Reddit({ this.edit, this.appBar, this.title });
  
  @override
  _RedditState createState() => _RedditState();
}

class _RedditState extends State<Reddit> {
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (context, mstate) {
        List<dynamic> members = (mstate as Members).members;
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

            return PostList(
              appBar: widget.appBar,
              title: widget.title,
              posts: reddits,
              community: true,
            );
          }
        );
      }
    );
  }
}
