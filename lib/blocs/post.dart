import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class PostBloc extends Bloc<PostEvent, PostState> {
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
    req: false,
    page: 0,
    posts: [],
    refresh: 0,
    hasReachedMax: false,
  );

  Stream<PostState> mapEventToState(PostEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();

    if (event is FetchPosts) {
      int _currentPage = 0;
      List<dynamic> _posts = [];
      String ident = event.ident;
      
      if(event.ident == '') {
        ident = await getString('mail');
      } 
      
      yield (currentState as Posts).copyWith(req: true);
      
      // load posts
      if (currentState is Posts) {
        if (event.refresh != true) {
          if ((currentState as Posts).hasReachedMax == true) {
            yield (currentState as Posts).copyWith(req: false);
            return;
          }
          _currentPage = (currentState as Posts).page + 1;
          _posts = (currentState as Posts).posts;
        }
      }

      List<dynamic> posts;
      if (event.ident == null) {
        posts = json.decode((await r.getPosts(
              ident: (currentState as Posts).ident,
              page: _currentPage,
        )).body)['posts'];
      } else {
        posts = json.decode((await r.getPosts(
              ident: ident,
              page: _currentPage,
        )).body)['posts'];
      }

      yield (currentState as Posts).copyWith(
        req: false,
        posts: _posts + posts,
        ident: ident,
        page: _currentPage,
        hasReachedMax: posts.length < 10 ? true : false,
        refresh: (currentState as Posts).refresh + 1,
      );

      if (event.refresh == true) {
        this.dispatch(FetchPosts(ident: ident));
      }
    }
  }
}

// ------ state ------
abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class Posts extends PostState {
  final bool req;
  final int page;
  final int refresh;
  final String ident;
  final List<dynamic> posts;
  final bool hasReachedMax;

  Posts({
      this.req,
      this.page,
      this.posts,
      this.refresh,
      this.ident,
      this.hasReachedMax,
  }): super([req, posts, ident, hasReachedMax, refresh, page]);
  
  Posts copyWith({
      bool req,
      int page,
      int refresh,
      String ident,
      List<dynamic> posts,
      bool hasReachedMax
  }) {
    return Posts(
      req: req ?? this.req,
      page: page ?? this.page,
      posts: posts ?? this.posts,
      refresh: refresh ?? this.refresh,
      ident: ident ?? this.ident,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  
  @override
  String toString() => 'Posts';
}


// ------ events -------
abstract class PostEvent extends Equatable {
  PostEvent([List props = const []]) : super(props);
}

class FetchPosts extends PostEvent {
  final bool refresh;
  final String ident;
  
  FetchPosts({
      this.refresh = false,
      this.ident
  });

  @override
  toString() => "FetchPosts";
}
