import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class RedditBloc extends Bloc<RedditEvent, RedditState> {
  final CommunityBloc c;
  
  RedditBloc({ this.c }) {
    c.state.listen((state) {
        if (state is CommunityFetchedSucceed) {
          this.dispatch(FetchReddits(community: state.current));
        }
    });
  }
  
  @override
  Stream<RedditState> transform(
    Stream<RedditEvent> events,
    Stream<RedditState> Function(RedditEvent event) next,
  ) {
    return super.transform(
      (events as Observable<RedditEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next
    );
  }

  @override
  RedditState get initialState => Reddits(
    page: 0,
    reddits: [],
    refresh: 0,
    hasReachedMax: false,
  );

  Stream<RedditState> mapEventToState(RedditEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();

    if (event is FetchReddits) {
      List<dynamic> reddits = json.decode((await r.getReddits(
            community: event.community,
            page: 0
      )).body)['reddits'];

      yield (currentState as Reddits).copyWith(
        reddits: reddits, page: 0
      );
    }
  }
}

// ------ state ------
abstract class RedditState extends Equatable {
  RedditState([List props = const []]) : super(props);
}

class Reddits extends RedditState {
  final int page;
  final int refresh;
  final List<dynamic> reddits;
  final bool hasReachedMax;

  Reddits({
      this.page,
      this.reddits,
      this.refresh,
      this.hasReachedMax,
  }): super([reddits, hasReachedMax, refresh, page]);
  
  Reddits copyWith({
      int page,
      int refresh,
      List<dynamic> reddits,
      bool hasReachedMax
  }) {
    return Reddits(
      page: page ?? this.page,
      reddits: reddits ?? this.reddits,
      refresh: refresh ?? this.refresh,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  
  @override
  String toString() => 'FetchedSucceed';
}


// ------ events -------
abstract class RedditEvent extends Equatable {
  RedditEvent([List props = const []]) : super(props);
}

class FetchReddits extends RedditEvent {
  final bool refresh;
  final String community;
  FetchReddits({
      this.refresh = false,
      this.community
  });

  @override
  toString() => "FetchReddits";
}
