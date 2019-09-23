import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/_post/post.dart';
import 'package:cdr_today/widgets/_post/reddit.dart';

// post list
class PostList extends StatefulWidget {
  final List<dynamic> posts;
  final bool edit;
  final bool hasReachedMax;
  final bool loading;
  final bool community;
  final SliverAppBar appBar;
  final SliverList title;
  PostList({
      this.edit = false,
      this.posts, // init in build.
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
  PostBloc _postBloc;
  RedditBloc _redditBloc;
  RefreshBloc _refreshBloc;
  double _scrollThreshold = 200.0;
  double _scrollIncipiency = (- kToolbarHeight);
  ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _redditBloc = BlocProvider.of<RedditBloc>(context);
    _refreshBloc = BlocProvider.of<RefreshBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    bool edit = widget.edit;
    List<dynamic> posts = widget.posts ?? [];
    if (posts.length == 0) {
      return CustomScrollView(
        slivers: <Widget>[
          widget.appBar ?? SliverPadding(padding: EdgeInsets.all(0)),
          widget.title ?? SliverPadding(padding: EdgeInsets.all(0)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: Text('暂无文章'),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 2.7
                  ),
                );
              }, childCount: 1,
            )
          )
        ]
      );
    }
    return CustomScrollView(
      slivers: <Widget>[
        widget.appBar ?? SliverPadding(padding: EdgeInsets.all(0)),
        widget.title ?? SliverPadding(padding: EdgeInsets.all(0)),
        widget.loading ? SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                child: CupertinoActivityIndicator(),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 2.7
                ),
              );
            }, childCount: 1,
          )
        ) : SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index == posts.length * 2) {
                if (posts.length < 10) return PostBottom();
                return widget.hasReachedMax == false
                ? PostLoader() : PostBottom();
              } else if (index.isEven) {
                int i = index ~/ 2;
                String id = posts[i]['id'];
                String document = posts[i]['document'];
                int timestamp = posts[i]['timestamp'];

                return widget.community ? RedditItem(
                  x: ArticleArgs(
                    id: id,
                    mail: posts[i]['mail'],
                    document: document,
                    timestamp: timestamp,
                    community: posts[i]['community'],
                    avatar: posts[i]['avatar'],
                    author: posts[i]['author'],
                  )
                ) : PostItem(
                  x: ArticleArgs(
                    id: id,
                    mail: posts[i]['author'],
                    document: document,
                    timestamp: timestamp,
                    community: posts[i]['community'],
                    // avatar: posts[i]['avatar'],
                    // author: posts[i]['author'],
                  )
                );
              }
              
              return widget.community
              ? SizedBox.shrink()
              : Divider(indent: 15.0, endIndent: 10.0);
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

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    BehaviorSubject scrollDelay = BehaviorSubject();
    
    scrollDelay.stream.delay(
      Duration(milliseconds: 1000)
    ).listen((t) {
        // dispatch events
        if (widget.community) {
          _refreshBloc.dispatch(RedditRefresh());
          _redditBloc.dispatch(FetchReddits(refresh: t));
        } else {
          _refreshBloc.dispatch(PostRefresh());
          _postBloc.dispatch(FetchSelfPosts(refresh: t));
        }
        
        Observable.timer(
          t, new Duration(milliseconds: 1000)
        ).listen((t) => setState(() { _scrollLock = false; }));
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
}

class PostLoader extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(30.0)
    );
  }
}

class PostBottom extends StatelessWidget {
  Widget build(BuildContext context) {
    return SizedBox.shrink();
    // return Container(
    //   child: Text(
    //     '— ∞ —',
    //     style: TextStyle(
    //       color: Colors.grey[500],
    //       fontSize: 13.0,
    //     )
    //   ),
    //   alignment: Alignment.center,
    //   padding: EdgeInsets.all(10.0),
    // );
  }
}
