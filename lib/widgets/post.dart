import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:cdr_today/navigations/args.dart';

class PostItem extends StatelessWidget {
  final ArticleArgs x;
  
  PostItem({ this.x });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(
          x.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)
        ),
        subtitle: Container(
          child: Text(
            x.content, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)
          ),
          padding: EdgeInsets.only(top: 10.0),
        ),
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
  final bool edit;
  final List<dynamic> posts;
  PostList({ this.edit, this.posts });
  
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<PostList> {
  bool _topLock = false;
  bool _bottomLock = false;
  // Divider's height is 20.0;
  // PostLoader's height is 90.0;
  final double _scrollThreshold = 110.0;
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 110.0
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
          return PostLoader();
        }
        
        String id = posts[index]['id'];
        String title = posts[index]['title'];
        String cover = posts[index]['cover'];
        String content = posts[index]['content'];

        content = content.replaceAll('\n', ' ');
        if (content.length > 120) {
          content = content.substring(0, 112);
          content = content + '...';
        }

        return PostItem(
          x: ArticleArgs(id: id, title: title, cover: cover, content: content)
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
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
        _scrollController.animateTo(
          i, curve: Curves.linear,
          duration: Duration (milliseconds: 500)
        );

        setState(() { _bottomLock = false; });
      }
    );

    // top refresh
    if (currentScroll <=  _scrollThreshold) {
      if (_bottomLock == true) {
        return;
      }

      setState(() { _bottomLock = true; });
      _scrollDelay.add(_scrollThreshold);
    }
    
    // bottom load
    if (maxScroll - currentScroll <= _scrollThreshold) {
      if (_bottomLock == true) {
        return;
      }

      setState(() { _bottomLock = true; });
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
