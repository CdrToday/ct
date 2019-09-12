import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/navigations/args.dart';

class PostItem extends StatelessWidget {
  final ArticleArgs x;
  
  PostItem({ this.x });
  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    return GestureDetector(
      child: ListTile(
        title: Text(
          x.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)
        ),
        subtitle: Container(
          child: Text(display(x.timestamp), style: TextStyle(fontSize: 11.0)),
          padding: EdgeInsets.only(top: 50.0),
          alignment:  AlignmentDirectional.bottomEnd
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 15.0
        )
      ),
      onTap: () {
        if (x.edit == true) {
          Navigator.pushNamed(context, '/user/edit', arguments: x);
        } else {
          Navigator.pushNamed(context, '/article', arguments: x);
        }
      }
    );
  }
}

// post list
class PostList extends StatefulWidget {
  final List<dynamic> posts;
  final bool edit;
  final bool hasReachedMax;
  PostList({ this.edit, this.posts, this.hasReachedMax });
  
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostList> {
  bool _scrollLock = false;
  PostBloc _postBloc;
  // Divider's height is 15.0;
  // PostLoader's height is 90.0;
  final double _scrollThreshold = 105.0;
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 105.0
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _postBloc = BlocProvider.of<PostBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    bool edit = widget.edit;
    List<dynamic> posts = widget.posts;

    // Add refresh circle;
    posts = [posts[0]] + posts;
    
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 52.0),
      itemCount: posts.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return PostLoader();
        }
        
        if (index >= posts.length) {
          if (widget.hasReachedMax == false) {
            return PostLoader();
          }
          return PostBottom();
        }
        
        String id = posts[index]['id'];
        String title = posts[index]['title'];
        String cover = posts[index]['cover'];
        String content = posts[index]['content'];
        int timestamp = posts[index]['timestamp'];

        content = content.replaceAll('\n', ' ');
        if (content.length > 120) {
          content = content.substring(0, 112);
          content = content + '...';
        }

        return PostItem(
          x: ArticleArgs(
            id: id,
            edit: edit,
            title: title,
            cover: cover,
            content: content,
            timestamp: timestamp
          )
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        indent: 15.0,
        endIndent: 10.0
      ),
      controller: _scrollController,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final lastPost = maxScroll - _scrollThreshold;

    final _scrollDelay = new BehaviorSubject<double>();

    _scrollDelay.stream.delay(
      Duration(milliseconds: 1000)
    ).listen((i) {
        i == _scrollThreshold ? _scrollController.animateTo(
          i, curve: Curves.linear,
          duration: Duration (milliseconds: 500)
        ) : '';

        _postBloc.dispatch(
          FetchSelfPosts(refresh: i == _scrollThreshold ? true : false)
        );
        
        Observable.timer(
          i, new Duration(milliseconds: 1000)
        ).listen((i) => setState(() { _scrollLock = false; }));
      }
    );

    // top refresh
    if (currentScroll <=  _scrollThreshold) {
      if (_scrollLock == true) {
        return;
      }
    
      setState(() { _scrollLock = true; });
      _scrollDelay.add(_scrollThreshold);
    }
    
    // bottom load
    if (maxScroll - currentScroll <= (_scrollThreshold + 100.0)) {
      if (widget.hasReachedMax == true) {
        return;
      }
      
      if (_scrollLock == true) {
        return;
      }
      setState(() { _scrollLock = true; });
      _scrollDelay.add(maxScroll - _scrollThreshold);
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
    return Container(
      child: Text('—— 到底了 ——'),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10.0),
    );
  }
}
