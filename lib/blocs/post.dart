import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
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
      ), next,
    );
  }
  
  @override
  PostState get initialState => UnFetched();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();

    if (event is FetchSelfPosts) {
      var res = await r.getPost();
      if (res.statusCode == 200) {
        PostAPI data = PostAPI.fromJson(json.decode(res.body));
        if (data.posts.length > 0) {
          yield FetchedSucceed(posts: data.posts);
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
abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class UnFetched extends PostState {
  @override
  String toString() => 'UnFetched';
}

class FetchedFailed extends PostState {
  @override
  String toString() => 'FetchedFailed';
}

class FetchedSucceed extends PostState {
  final dynamic posts;
  final bool hasReachedMax;
  
  FetchedSucceed({ this.posts, this.hasReachedMax });
  @override
  String toString() => 'FetchedSucceed';
}

class EmptyList extends PostState {
  @override
  String toString() => 'EmptyList';
}

// ----------- events ------------
abstract class PostEvent extends Equatable {}

class FetchSelfPosts extends PostEvent {
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
