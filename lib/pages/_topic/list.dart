import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/topic.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/post.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class TopicList extends StatefulWidget {
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  List<dynamic> topics = [];
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicBloc, TopicState>(
      builder: (context, state) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text('话题'),
            leading: CtClose(),
            // trailing: self? SizedBox.shrink() : EditAction(context),
            border: null
          ),
          child: Material(
            color: Colors.transparent,
            child: PostList(
              // appBar: widget.appBar,
              // title: widget.title,
              type: 'topic',
              posts: (state as Topics).topics,
              community: true,
              // loading: true,
              // hasReachedMax: (state as Reddits).hasReachedMax,
            ),
          ),
          resizeToAvoidBottomInset: true,
        );
      }
    );
  }
}
