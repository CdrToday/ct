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

  if (res.statusCode != 200) {
    return getCommunities();
  }
  
  return json.decode(res.body)['communities'];
}

// ------- bloc -----
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final UserBloc u;
  CommunityBloc({ this.u }) {
    u.state.listen((state) {
        if (state is UserInited) {
          this.dispatch(FetchCommunity());
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
        Duration(milliseconds: 100),
      ), next,
    );
  }
  
  @override
  CommunityState get initialState => EmptyCommunityState();

  @override
  Stream<CommunityState> mapEventToState(CommunityEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();
    
    if (event is FetchCommunity) {
      var communities = await getCommunities();
      
      if (currentState is EmptyCommunityState) {
        yield CommunityFetchedSucceed(
          current: communities[0]['id'],
          communities: communities,
          refresh: 0,
        );
        return;
      }
      
      yield (currentState as CommunityFetchedSucceed).copyWith(
        communities: communities,
        refresh: (currentState as CommunityFetchedSucceed).refresh + 1,
      );
    } else if (event is ChangeCurrentCommunity) {
      yield (currentState as CommunityFetchedSucceed).copyWith(
        current: event.id
      );
    }
  }
}

// ------------- state ------------
abstract class CommunityState extends Equatable {
  CommunityState([List props = const []]) : super(props);
}

class EmptyCommunityState extends CommunityState {
  @override
  toString() => "EmptyCommunityState";
}

class CommunityFetchedSucceed extends CommunityState {
  final String current;
  final List<dynamic> communities;
  final int refresh;
  
  CommunityFetchedSucceed({
      this.current, this.communities, this.refresh = 0,
  }) : super([ current, communities, refresh ]);

  CommunityFetchedSucceed copyWith({
      List<dynamic> communities, int refresh, String current
  }) {
    return CommunityFetchedSucceed(
      current: current ?? this.current,
      communities: communities ?? this.communities,
      refresh: refresh ?? this.refresh
    );
  }
}

// ------------- events -------------
abstract class CommunityEvent extends Equatable {}

class FetchCommunity extends CommunityEvent {
  @override
  toString() => "FetchCommunity";
}

class ChangeCurrentCommunity extends CommunityEvent {
  final String id;
  ChangeCurrentCommunity({ this.id });
  @override
  toString() => "ChangeCurrentCommunity";
}
