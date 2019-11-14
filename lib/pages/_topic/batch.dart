import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/topic.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class TopicBatch extends StatefulWidget {
  final String topic;
  TopicBatch({ this.topic });

  @override
  _TopicBatchState createState() => _TopicBatchState();
}

class _TopicBatchState extends State<TopicBatch> {
  List<dynamic> batch = [];

  initState() {
    final TopicBloc _bloc = BlocProvider.of<TopicBloc>(context);
    _bloc.dispatch(BatchTopic(topic: widget.topic));
  }

  deactivate() {
    final TopicBloc _bloc = BlocProvider.of<TopicBloc>(context);
    if (ModalRoute.of(context).isCurrent) _bloc.dispatch(BatchTopic(topic: widget.topic));
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (mContext, mState) => BlocBuilder<TopicBloc, TopicState>(
        builder: (context, state) {
          List<dynamic> members = (mState as Members).members;
          var topicState = (state as Topics);
          if (
            topicState.batch.length > 1 && (topicState.batch[
                topicState.batch.length - 1
              ]['id'] == widget.topic)
          ) {
            batch = topicState.batch;
          }

          for (var r in batch) {
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

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('...'),
              leading: CtClose(
                onTap: () async {
                  final TopicBloc _bloc = BlocProvider.of<TopicBloc>(context);
                  _bloc.dispatch(BatchTopic(topic: ''));
                  Navigator.maybePop(context);
                }
              ),
              // trailing: self? SizedBox.shrink() : EditAction(context),
              border: null
            ),
            child: Material(
              color: Colors.transparent,
              child: PostList(
                // appBar: widget.appBar,
                // title: widget.title,
                posts: batch,
                community: true,
                loading: true,
                // hasReachedMax: (state as Reddits).hasReachedMax,
              ),
            ),
            resizeToAvoidBottomInset: true,
          );
        }
      )
    );
  }
}
