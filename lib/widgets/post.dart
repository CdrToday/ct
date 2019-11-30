import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/topic.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/_post/reddit.dart';

// post list
class PostList extends StatefulWidget {
  final List<dynamic> posts;
  final bool hasReachedMax;
  final bool loading;
  final bool community;
  final String type;
  final String mail;
  final CupertinoSliverNavigationBar appBar;
  final SliverList title;
  PostList({
      this.posts, // init in build.
      this.mail,
      this.type = '',
      this.hasReachedMax = false,
      this.appBar,
      this.title,
      this.loading = false,
      this.community = false
  });
  
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostList> {
  bool _scrollLock = false;
  TopicBloc _topicBloc;
  PostBloc _postBloc;
  RedditBloc _redditBloc;
  RefreshBloc _refreshBloc;
  double _scrollThreshold = 500.0;
  double _scrollIncipiency = (- kToolbarHeight);
  ScrollController _scrollController;
  ScrollController _lsc;
  GlobalKey stickyKey = GlobalKey();
  double topHeight;
  
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
        if (stickyKey.currentContext != null) {
          setState(() { topHeight = stickyKey.currentContext.size.height; });
        }
    });
    
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _lsc = ScrollController();
    _lsc.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _topicBloc = BlocProvider.of<TopicBloc>(context);
    _redditBloc = BlocProvider.of<RedditBloc>(context);
    _refreshBloc = BlocProvider.of<RefreshBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    List<dynamic> posts = widget.posts ?? [];
    if (posts.length == 0 || posts == null) {
      return Column(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              widget.appBar ?? SliverPadding(padding: EdgeInsets.all(0)),
              widget.title ?? SliverPadding(padding: EdgeInsets.all(0)),
            ],
            shrinkWrap: true,
            key: stickyKey,
          ),
          SizedBox(height: 50.0),
          /// [TODO]: why overflow?
          Builder(
            builder: (context) {
              // if (topHeight == null) return Container();
              double _height = MediaQuery.of(context).size.height;
              double height = _height > 750 ? (
                _height - kToolbarHeight * 4
              ) : (
                _height - kToolbarHeight * 3
              );

              return SingleChildScrollView(
                child: Container(
                  child: widget.loading
                  ? CupertinoActivityIndicator()
                  : Text(
                    '暂无内容',
                    style: TextStyle(
                      color: CtColors.primary
                    ),
                  ),
                  alignment: Alignment.center,
                  height: height,
                  padding: EdgeInsets.only(
                    bottom: 50000 / MediaQuery.of(context).size.height,
                  ),
                ),
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
              );
            }
          ),
        ]
      );
    }

    return CustomScrollView(
      slivers: <Widget>[
        widget.appBar ?? SliverPadding(padding: EdgeInsets.all(0)),
        widget.title ?? SliverPadding(padding: EdgeInsets.all(0)),
        SliverPadding(padding: EdgeInsets.all(3.0)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index == posts.length * 2 - 1) {
                if (posts.length < 10) return SizedBox.shrink();
                if (widget.hasReachedMax == true) return SizedBox.shrink();
              } else if (index == posts.length * 2) {
                if (posts.length < 10) return PostBottom();
                return widget.hasReachedMax == false
                ? PostLoader(community: widget.community) : PostBottom();
              } else if (index.isEven) {
                int i = index ~/ 2;
                String id = posts[i]['id'];
                String document = posts[i]['document'];
                int timestamp = posts[i]['timestamp'];
                
                return RedditItem(
                  x: ArticleArgs(
                    id: id,
                    type: widget.type,
                    mail: posts[i]['mail'],
                    topic: posts[i]['topic'],
                    batch: widget.community,
                    document: document,
                    timestamp: timestamp,
                    community: posts[i]['community'],
                    avatar: posts[i]['avatar'],
                    author: posts[i]['author'],
                  )
                );
              }

              return SizedBox.shrink();
            },
            childCount: posts.length * 2 + 1
          )
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: kToolbarHeight)
        )
      ],
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    BehaviorSubject scrollDelay = BehaviorSubject();

    scrollDelay.stream.delay(
      Duration(milliseconds: 1000)
    ).listen((b) {
        // dispatch events
        _topicBloc.dispatch(UpdateTopic());

        if (widget.community) {
          _redditBloc.dispatch(FetchReddits(refresh: b));
        } else {
          _postBloc.dispatch(FetchPosts(refresh: b));
        }
        
        Observable.timer(
          b, new Duration(milliseconds: 1000)
        ).listen((b) => setState(() { _scrollLock = false; }));
      }
    );

    // top refresh
    if (currentScroll <= _scrollIncipiency) {
      if (_scrollLock == true) {
        return;
      }
      setState(() { _scrollLock = true; });
      scrollDelay.add(true);
    }

    // return if no more
    if (widget.posts == null) return;
    if (widget.posts.length < 10) return;
    
    // bottom load
    if (currentScroll + _scrollThreshold >= maxScroll) {
      if (widget.hasReachedMax == true) {
        return;
      }
      
      if (_scrollLock == true) {
        return;
      }
      setState(() { _scrollLock = true; });
      scrollDelay.add(false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class PostLoader extends StatelessWidget {
  final bool community;
  PostLoader({ this.community });

  Widget build(BuildContext context) {
    return Container(
      child: Icon(Icons.arrow_downward),
      padding: EdgeInsets.only(top: 25.0)
    );
  }
}

class PostBottom extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
