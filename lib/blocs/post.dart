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
          this.dispatch(FetchSelfPosts());
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
  PostState get initialState => UnFetched();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is FetchSelfPosts) {
      // refresh posts
      if (event.refresh == true) {
        var posts = await getPosts(page: 0);
        yield (currentState as FetchedSucceed).copyWith(
          page: 0,
          posts: posts,
          hasReachedMax: false,
          refresh: (currentState as FetchedSucceed).refresh + 1,
        );
        return;
      }

      int _currentPage = 0;
      List<dynamic> _posts = [];
      bool _hasReachedMax = false;
      
      // load posts
      if (currentState is FetchedSucceed) {
        if ((currentState as FetchedSucceed).hasReachedMax == true) {
          return;
        }
        
        _currentPage = (currentState as FetchedSucceed).page + 1;
        _posts = (currentState as FetchedSucceed).posts;
      }

      // get posts
      var posts = await getPosts(page: _currentPage);
      
      yield FetchedSucceed(
        page: _currentPage,
        posts: _posts + posts,
        hasReachedMax: _hasReachedMax,
        refresh: 0,
      );
      return;
    } else if (event is CleanList) {
      yield UnFetched();
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

class FetchedSucceed extends PostState {
  final int page;
  final int refresh;
  final List<dynamic> posts;
  final bool hasReachedMax;
  
  FetchedSucceed({
      this.page,
      this.posts,
      this.refresh,
      this.hasReachedMax,
  }): super([posts, hasReachedMax, refresh, page]);
  
  FetchedSucceed copyWith({
      int page,
      int refresh,
      List<dynamic> posts,
      bool hasReachedMax
  }) {
    return FetchedSucceed(
      page: page ?? this.page,
      posts: posts ?? this.posts,
      refresh: refresh ?? this.refresh,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  
  @override
  String toString() => 'FetchedSucceed';
}

// ----------- events ------------
abstract class PostEvent extends Equatable {}

class FetchSelfPosts extends PostEvent {
  final bool refresh;
  FetchSelfPosts({ this.refresh });
  
  @override
  String toString() => 'FetchSelfPosts';
}

class CleanList extends PostEvent {
  @override
  String toString() => 'CleanList';
}

// ------------ api --------------
class PostAPI {
  final List<dynamic> posts;
  PostAPI({ this.posts });
  
  factory PostAPI.fromJson(Map<String, dynamic> json) {
    return PostAPI(posts: json['posts']);
  }
}
