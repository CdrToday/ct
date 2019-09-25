import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/req.dart' as xReq;

Future<List<dynamic>> getPosts({int page}) async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getPost(page: page);

  if (res.statusCode != 200) return getPosts(page: page);
  return json.decode(res.body)['posts'];
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final UserBloc u;
  
  PostBloc({ this.u }) {
    u.state.listen((state) {
        if (state is UserInited) {
          this.dispatch(FetchPosts(refresh: true));
        }
    });
  }
  
  @override
  Stream<PostState> transform(
    Stream<PostEvent> events,
    Stream<PostState> Function(PostEvent event) next,
  ) {
    return super.transform(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next
    );
  }
  
  @override
  PostState get initialState => Posts(
    page: 0,
    posts: [],
    refresh: 0,
    hasReachedMax: false
  );

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchPosts) {
      // refresh posts
      int _currentPage = 0;
      List<dynamic> _posts = [];
      
      // load posts
      if (currentState is Posts) {
        if (event.refresh != true) {
          if ((currentState as Posts).hasReachedMax == true) return;
          _currentPage = (currentState as Posts).page + 1;
          _posts = (currentState as Posts).posts;
        }
      }
      
      // get posts
      var posts = await getPosts(page: _currentPage);
      yield Posts(
        page: _currentPage,
        posts: _posts + posts,
        hasReachedMax: posts.length == 0 ? true : false,
        refresh: (currentState as Posts).refresh + 1,
      );
    }
  }
}

// ----------- state -------------
abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class UnFetched extends PostState {
  @override
  String toString() => 'UnFetched';
}

class Posts extends PostState {
  final int page;
  final int refresh;
  final List<dynamic> posts;
  final bool hasReachedMax;
  
  Posts({
      this.page,
      this.posts,
      this.refresh,
      this.hasReachedMax,
  }): super([posts, hasReachedMax, refresh, page]);
  
  Posts copyWith({
      int page,
      int refresh,
      List<dynamic> posts,
      bool hasReachedMax
  }) {
    return Posts(
      page: page ?? this.page,
      posts: posts ?? this.posts,
      refresh: refresh ?? this.refresh,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  
  @override
  String toString() => 'Posts';
}

// ----------- events ------------
abstract class PostEvent extends Equatable {}

class FetchPosts extends PostEvent {
  final bool refresh;
  FetchPosts({ this.refresh });
  
  @override
  String toString() => 'FetchPosts';
}
