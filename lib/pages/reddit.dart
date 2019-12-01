// @salute to reddit
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/topic.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/_actions/edit.dart';

class RedditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: BlocBuilder<RedditBloc, RedditState>(
          builder: (context, state) {
            if ((state as Reddits).req) return CupertinoActivityIndicator();
            return CommunityName(qr: true);
          }
        ),
        leading: CtNoRipple(
          size: 22.0,
          icon: Icons.code,
          onTap: () => Navigator.of(
            context, rootNavigator: true
          ).pushNamed('/community/topics')
        ),
        trailing: EditAction(context),
        border: null
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

            return BlocBuilder<TopicBloc, TopicState>(
              builder: (context, tState) {
                var topics = (tState as Topics).topics;
                for (var r in reddits) {
                  if (r['topic'] != '') {
                    r.putIfAbsent('topicTitle', () {
                        for (var t in topics) {
                          if (
                            r['topic'] == t['id'] &&
                            r['id'] != r['topic']
                          ) {
                            List<dynamic> json = jsonDecode(t['document']);
                            String topicTitle = '';
                            for (var i in json) {
                              if (i['insert'].contains(RegExp(r'[\u4e00-\u9fa5_a-zA-Z0-9]'))) {
                                if (topicTitle == '') {
                                  topicTitle = i['insert'].replaceAll(RegExp(r'\n'), '');
                                }
                              }
                            }
                            return topicTitle;
                          }
                        }
                        return '';
                    });
                  }
                }

                return PostList(
                  appBar: widget.appBar,
                  title: widget.title,
                  type: 'reddit',
                  posts: reddits,
                  topics: (tState as Topics).topics,
                  community: true,
                  hasReachedMax: (state as Reddits).hasReachedMax,
                );
              }
            );
          }
        );
      }
    );
  }
}
