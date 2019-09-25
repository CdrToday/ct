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
  AuthorPostState get initialState => AuthorPosts(
    page: 0,
    posts: [],
    hasReachedMax: false,
    refresh: 0,
  );

  @override
  Stream<AuthorPostState> mapEventToState(AuthorPostEvent event) async* {
    if (event is FetchAuthorPosts) {
      // refresh posts
      int _currentPage = 0;
      List<dynamic> _posts = [];
      
      // load posts
      if (currentState is AuthorPosts) {
        if (event.refresh != true) {
          if ((currentState as AuthorPosts).hasReachedMax == true) return;
          _currentPage = (currentState as AuthorPosts).page + 1;
          _posts = (currentState as AuthorPosts).posts;
        }
      }
      
      // get posts
      var _mail = event.mail != null ? event.mail :(
        currentState as AuthorPosts
      ).mail;
      var posts = await getAuthorPosts(page: _currentPage, mail: _mail);
      yield AuthorPosts(
        mail: _mail,
        page: _currentPage,
        posts: _posts + posts,
        hasReachedMax: posts.length == 0 ? true : false,
        refresh: (currentState as AuthorPosts).refresh + 1,
      );
    }
  }
}

// ----------- state -------------
abstract class AuthorPostState extends Equatable {
  AuthorPostState([List props = const []]) : super(props);
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
  String toString() => 'AuthorPosts';
}

// ----------- events ------------
abstract class AuthorPostEvent extends Equatable {}

class FetchAuthorPosts extends AuthorPostEvent {
  final bool refresh;
  final String mail;
  FetchAuthorPosts({ this.refresh, this.mail });
  
  @override
  String toString() => 'FetchAuthorPosts';
}
