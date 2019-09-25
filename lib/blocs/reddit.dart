import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class RedditBloc extends Bloc<RedditEvent, RedditState> {
  final CommunityBloc c;
  
  RedditBloc({ this.c }) {
    c.state.listen((state) {
        if (state is Communities) {
          // not init state.
          if (state.current != null && state.current != '') {
            this.dispatch(FetchReddits(community: state.current, refresh: true));
          }
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
      int _currentPage = 0;
      List<dynamic> _reddits = [];

      // load reddits
      if (currentState is Reddits) {
        if (event.refresh != true) {
          if ((currentState as Reddits).hasReachedMax == true) return;
          _currentPage = (currentState as Reddits).page + 1;
          _reddits = (currentState as Reddits).reddits;
        }
      }

      List<dynamic> reddits;
      if (event.community == null) {
        reddits = json.decode((await r.getReddits(
              community: (currentState as Reddits).community,
              page: _currentPage,
        )).body)['reddits'];
      } else {
        reddits = json.decode((await r.getReddits(
              community: event.community,
              page: _currentPage,
        )).body)['reddits'];
      }

      yield (currentState as Reddits).copyWith(
        reddits: _reddits + reddits,
        community: event.community,
        page: _currentPage,
        hasReachedMax: reddits.length == 0 ? true : false,
        refresh: (currentState as Reddits).refresh + 1,
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
  final String community;
  final List<dynamic> reddits;
  final bool hasReachedMax;

  Reddits({
      this.page,
      this.reddits,
      this.refresh,
      this.community,
      this.hasReachedMax,
  }): super([reddits, community, hasReachedMax, refresh, page]);
  
  Reddits copyWith({
      int page,
      int refresh,
      String community,
      List<dynamic> reddits,
      bool hasReachedMax
  }) {
    return Reddits(
      page: page ?? this.page,
      reddits: reddits ?? this.reddits,
      refresh: refresh ?? this.refresh,
      community: community ?? this.community,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
  
  @override
  String toString() => 'Reddits';
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
