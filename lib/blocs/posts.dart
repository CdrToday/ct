import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  @override
  PostsState get initialState => UnFetched();

  @override
  Stream<PostsState> mapEventToState(PostsEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();

    if (event is FetchSelfArticles) {
      var res = await r.getPosts();
      if (res.statusCode == 200) {
        PostsAPI posts = PostsAPI.fromJson(json.decode(res.body));
        if (posts.posts.length > 0) {
          yield FetchedSucceed(list: posts.posts);
        } else {
          yield EmptyList();
        }
      } else {
        yield FetchedFailed();
      }
      return;
    } else if (event is CleanList) {
      yield UnFetched();
    }
    return;
  }
}

// ----------- state -------------
abstract class PostsState extends Equatable {
  PostsState([List props = const []]) : super(props);
}

class UnFetched extends PostsState {
  @override
  String toString() => 'UnFetched';
}

class FetchedFailed extends PostsState {
  @override
  String toString() => 'FetchedFailed';
}

class FetchedSucceed extends PostsState {
  final dynamic list;
  FetchedSucceed({ this.list });
  @override
  String toString() => 'FetchedSucceed';
}

class EmptyList extends PostsState {
  @override
  String toString() => 'EmptyList';
}

// ----------- events ------------
abstract class PostsEvent extends Equatable {}

class FetchSelfArticles extends PostsEvent {
  @override
  String toString() => 'FetchSelfArticles';
}

class CleanList extends PostsEvent {
  @override
  String toString() => 'CleanList';
}

// ------------ api --------------
class PostsAPI {
  final List<dynamic> posts;
  PostsAPI({ this.posts });
  
  factory PostsAPI.fromJson(Map<String, dynamic> json) {
    return PostsAPI(posts: json['posts']);
  }
}
