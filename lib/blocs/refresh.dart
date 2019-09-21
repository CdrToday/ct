import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/blocs/community.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  final PostBloc p;
  final CommunityBloc c;
  
  RefreshBloc({ this.p, this.c }) {
    p.state.listen((state) {
        if (state is FetchedSucceed) {
          this.dispatch(PostRefreshEndEvent());
        }
    });

    c.state.listen((state) {
        if (state is CommunityFetchedSucceed) {
          if (state.refresh == 0) return;
          this.dispatch(CommunityRefreshTrigger());
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
  RefreshState get initialState => RefreshIncipency();

  @override
  Stream<RefreshState> mapEventToState(RefreshEvent event) async* {
    if (event is PostRefreshEvent) {
      yield PostRefreshStart();
    } else if (event is PostRefreshEndEvent) {
      yield PostRefreshEnd();
    } else if (event is CommunityRefreshTrigger) {
      if (currentState is CommunityRefreshing) {
        yield RefreshIncipency();
        return;
      }

      yield CommunityRefreshing();
    }

    return;
  }
}

// -------------- states ------------------
abstract class RefreshState extends Equatable {
  RefreshState([List props = const []]) : super(props);
}

class RefreshIncipency extends RefreshState {
  @override
  String toString() => 'RefreshIncipency';
}

class PostRefreshStart extends RefreshState {
  @override
  String toString() => 'PostRefreshStart';
}

class PostRefreshEnd extends RefreshState {
  @override
  String toString() => 'PostRefreshEnd';
}

class CommunityRefreshing extends RefreshState {
  @override
  String toString() => 'CommunityRefreshing';
}

// -------------- events ----------------
abstract class RefreshEvent extends Equatable {}

class PostRefreshEvent extends RefreshEvent {
  @override
  String toString() => 'PostRefreshEvent';
}

class CommunityRefreshTrigger extends RefreshEvent {
  @override
  String toString() => 'CommunityRefreshTrigger';
}

class PostRefreshEndEvent extends RefreshEvent {
  @override
  String toString() => 'PostRefreshEndEvent';
}
