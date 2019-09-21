import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

Future<List<dynamic>> getAuthorPosts({int page, String mail}) async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getAuthorPost(page: page, mail: mail);
  if (res.statusCode != 200) return getAuthorPosts(page: page, mail: mail);
  return json.decode(res.body)['posts'];
}

class AuthorPostBloc extends Bloc<AuthorPostEvent, AuthorPostState> {
  @override
  Stream<AuthorPostState> transform(
    Stream<AuthorPostEvent> events,
    Stream<AuthorPostState> Function(AuthorPostEvent event) next,
  ) {
    return super.transform(
      (events as Observable<AuthorPostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next
    );
  }
  
  @override
  AuthorPostState get initialState => AuthorPostsUnFetched();

  @override
  Stream<AuthorPostState> mapEventToState(AuthorPostEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();
    if (event is FetchAuthorPosts) {
      if (event.mail == null) return;
      // refresh posts
      if (event.refresh == true) {
        var posts = await getAuthorPosts(page: 0, mail: event.mail);
        yield (currentState as AuthorPosts).copyWith(
          page: 0,
          posts: posts,
          hasReachedMax: false,
          refresh: (currentState as AuthorPosts).refresh + 1,
        );
        return;
      }

      int _currentPage = 0;
      List<dynamic> _posts = [];
      bool _hasReachedMax = false;
      
      // load posts
      if (currentState is AuthorPosts) {
        if ((currentState as AuthorPosts).hasReachedMax == true) {
          return;
        }
        
        _currentPage = (currentState as AuthorPosts).page + 1;
        _posts = (currentState as AuthorPosts).posts;
      }

      // get posts
      var posts = await getAuthorPosts(page: _currentPage, mail: event.mail);
      
      yield AuthorPosts(
        page: _currentPage,
        posts: _posts + posts,
        hasReachedMax: _hasReachedMax,
        refresh: 0,
      );
      return;
    }
  }
}

// ----------- state -------------
abstract class AuthorPostState extends Equatable {
  AuthorPostState([List props = const []]) : super(props);
}

class AuthorPostsUnFetched extends AuthorPostState {
  @override
  String toString() => 'UnFetched';
}

class AuthorPosts extends AuthorPostState {
  final String mail;
  final int page;
  final int refresh;
  final List<dynamic> posts;
  final bool hasReachedMax;
  
  AuthorPosts({
      this.mail,
      this.page,
      this.posts,
      this.refresh,
      this.hasReachedMax,
  }): super([mail, posts, hasReachedMax, refresh, page]);
  
  AuthorPosts copyWith({
      String mail,
      int page,
      int refresh,
      List<dynamic> posts,
      bool hasReachedMax
  }) {
    return AuthorPosts(
      mail: mail ?? this.mail,
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
abstract class AuthorPostEvent extends Equatable {}

class FetchAuthorPosts extends AuthorPostEvent {
  final bool refresh;
  final String mail;
  FetchAuthorPosts({ this.refresh, this.mail });
  
  @override
  String toString() => 'AuthorPosts';
}
