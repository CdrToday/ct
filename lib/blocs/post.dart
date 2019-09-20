import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class PostBloc extends Bloc<PostEvent, PostState> {
  final EditBloc e;
  
  PostBloc({ this.e }) {
    e.state.listen((state) {
        if (state is PublishSucceed) {
          this.dispatch(FetchSelfPosts(refresh: true));
        } else if (state is UpdateSucceed) {
          print('aaa');
          this.dispatch(FetchSelfPosts(refresh: true));
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
    xReq.Requests r = await xReq.Requests.init();
    
    if (event is FetchSelfPosts) {
      // refresh posts
      if (event.refresh == true) {
        var res = await r.getPost(page: 0);
        
        if (res.statusCode == 200) {
          PostAPI data = PostAPI.fromJson(json.decode(res.body));
          if (currentState is FetchedSucceed) {
            yield (currentState as FetchedSucceed).copyWith(
              page: 0,
              posts: data.posts,
              hasReachedMax: false,
              refresh: (currentState as FetchedSucceed).refresh != null
              ? (currentState as FetchedSucceed).refresh + 1
              : 1
            );
            return;
          }

          yield FetchedSucceed(
            page: 0,
            posts: data.posts,
            hasReachedMax: false,
          );
          
          return;
        }

        if (currentState is UnFetched) {
          yield FetchedFailed();
        } else if (currentState is FetchedFailed) {
          yield FetchedFailed();
        }

        yield (currentState as FetchedSucceed).copyWith(
          refresh: (currentState as FetchedSucceed).refresh != null
          ? (currentState as FetchedSucceed).refresh + 1
          : 1
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
      var res = await r.getPost(page: _currentPage);
      
      if (res.statusCode == 200) {
        PostAPI data = PostAPI.fromJson(json.decode(res.body));
        yield data.posts.isEmpty
        ? (currentState as FetchedSucceed).copyWith(hasReachedMax: true)
        : FetchedSucceed(
          page: _currentPage,
          posts: _posts + data.posts,
          hasReachedMax: _hasReachedMax,
        );

        return;
      }

      yield (currentState as FetchedSucceed).copyWith(
        refresh: (currentState as FetchedSucceed).refresh + 1
      );
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

class FetchedFailed extends PostState {
  FetchedFailed(): super();
  @override
  String toString() => 'FetchedFailed';
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
