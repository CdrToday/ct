import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/topic.dart';
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
  initState() {
    final TopicBloc _bloc = BlocProvider.of<TopicBloc>(context);
    _bloc.dispatch(BatchTopic(topic: widget.topic));
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('...'),
            leading: CtClose(),
            // trailing: self? SizedBox.shrink() : EditAction(context),
            border: null
          ),
          child: Material(
            color: Colors.transparent,
            child: PostList(
              // appBar: widget.appBar,
              // title: widget.title,
              posts: (state as Topics).batch,
              community: true,
              // hasReachedMax: (state as Reddits).hasReachedMax,
            ),
          ),
          resizeToAvoidBottomInset: true,
        );
      }
    );
  }
}
