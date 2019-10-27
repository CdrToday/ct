import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/req.dart' as xReq;

Future<List<dynamic>> getCommunities() async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getCommunities();
  return json.decode(res.body)['communities'];
}

// ------- bloc -----
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final UserBloc u;
  
  CommunityBloc({ this.u }) {
    u.state.listen((state) {
        if (state is UserInited) {
          if (state.local == false) this.dispatch(FetchCommunities());
        }
    });
  }

  @override
  Stream<CommunityState> transform(
    Stream<CommunityEvent> events,
    Stream<CommunityState> Function(CommunityEvent event) next,
  ) {
    return super.transform(
      (events as Observable<CommunityEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  CommunityState get initialState => Communities(
    communities: [],
    refresh: 0,
  );

  @override
  Stream<CommunityState> mapEventToState(CommunityEvent event) async* {
    if (event is FetchCommunities) {
      var communities = await getCommunities();
      yield (currentState as Communities).copyWith(
        current: communities.length > 0 ? communities[0]['id'] : '',
        communities: communities.length > 0 ? communities : [],
        refresh: (currentState as Communities).refresh + 1,
      );
    } else if (event is ChangeCurrentCommunity) {
      yield (currentState as Communities).copyWith(
        current: event.id,
        refresh: -1,
      );
      yield (currentState as Communities).copyWith(refresh: 0);
    } else if (event is RefreshCommunities) {
      var communities = await getCommunities();
      yield (currentState as Communities).copyWith(
        communities: communities,
        refresh: (currentState as Communities).refresh + 1
      );
    }
  }
}

// ------------- state ------------
abstract class CommunityState extends Equatable {
  CommunityState([List props = const []]) : super(props);
}

class Communities extends CommunityState {
  final String current;
  final List<dynamic> communities;
  final int refresh;
  
  Communities({
      this.current, this.communities, this.refresh = 0,
  }) : super([ current, communities, refresh ]);

  Communities copyWith({
      List<dynamic> communities, int refresh, String current
  }) {
    return Communities(
      current: current ?? this.current,
      communities: communities ?? this.communities,
      refresh: refresh ?? this.refresh
    );
  }
}

// ------------- events -------------
abstract class CommunityEvent extends Equatable {}

class FetchCommunities extends CommunityEvent {
  @override
  toString() => "FetchCommunities";
}

class UpdateCommunities extends CommunityEvent {
  @override
  toString() => "UpdateCommunities";
}

class RefreshCommunities extends CommunityEvent {
  @override
  toString() => "RefreshCommunities";
}

class ChangeCurrentCommunity extends CommunityEvent {
  final String id;
  ChangeCurrentCommunity({ this.id });
  @override
  toString() => "ChangeCurrentCommunity";
}
