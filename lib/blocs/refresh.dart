import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/blocs/trigger.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  final PostBloc p;
  final CommunityBloc c;
  
  RefreshBloc({ this.p, this.c }) {
    p.state.listen((state) {
        if (state is FetchedSucceed) {
          this.dispatch(PostRefresher(refresh: false));
        }
    });
    
    c.state.listen((state) {
        if (state is CommunityFetchedSucceed) {
          if (state.refresh == 0) return;
          this.dispatch(CommunityRefresher(refresh: false));
        }
    });
  }
  
  @override
  Stream<RefreshState> transform(
    Stream<RefreshEvent> events,
    Stream<RefreshState> Function(RefreshEvent event) next,
  ) {
    return super.transform(
      (events as Observable<RefreshEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  RefreshState get initialState => Refresher(post: false, community: false);

  @override
  Stream<RefreshState> mapEventToState(RefreshEvent event) async* {
    if (event is PostRefresher) {
      yield (currentState as Refresher).copyWith(
        post: event.refresh ?? !(currentState as Refresher).post
      );
    } else if (event is CommunityRefresher) {
      yield (currentState as Refresher).copyWith(
        community: event.refresh ?? !(currentState as Refresher).community
      );
    } 

    return;
  }
}

// -------------- states ------------------
abstract class RefreshState extends Equatable {
  RefreshState([List props = const []]) : super(props);
}

class Refresher extends RefreshState {
  final bool post;
  final bool community;
  Refresher({
      this.post,
      this.community
  }) : super([ post, community ]);

  Refresher copyWith({
      bool post, bool community
  }) {
    return Refresher(
      post: post ?? this.post,
      community: community ?? this.community
    );
  }
}

// -------------- events ----------------
abstract class RefreshEvent extends Equatable {}

class PostRefresher extends RefreshEvent {
  bool refresh;
  PostRefresher({ this.refresh });
  @override
  String toString() => 'PostRefresher';
}

class CommunityRefresher extends RefreshEvent {
  bool refresh;
  CommunityRefresher({ this.refresh });
  @override
  String toString() => 'CommunityRefresher';
}
