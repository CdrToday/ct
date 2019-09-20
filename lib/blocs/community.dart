import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

Future<List<dynamic>> getCommunities() async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getCommunities();

  if (res.statusCode != 200) {
    return getCommunities();
  }

  GetCommunitiesResult _data = GetCommunitiesResult.fromJson(json.decode(res.body));
  return _data.communities;
}

// ------- bloc -----
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
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
  CommunityState get initialState => EmptyCommunityState();

  @override
  Stream<CommunityState> mapEventToState(CommunityEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();

    if (event is FetchCommunity) {
      if (currentState is EmptyCommunityState) {
        yield CommunityFetchedSucceed(communities: await getCommunities());
        return;
      }
      
      yield (event.refresh == true)
      ? (currentState as CommunityFetchedSucceed).copyWith(
        communities: await getCommunities(),
        refresh: (currentState as CommunityFetchedSucceed).refresh != null?
        (currentState as CommunityFetchedSucceed).refresh + 1 : 1,
      ) : CommunityFetchedSucceed(communities: await getCommunities());
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
  final List<dynamic> communities;
  final int refresh;
  
  CommunityFetchedSucceed({
      this.communities, this.refresh,
  }) : super([ communities, refresh ]);

  CommunityFetchedSucceed copyWith({
      List<dynamic> communities,
      int refresh,
  }) {
    return CommunityFetchedSucceed(
      communities: communities ?? this.communities,
      refresh: refresh ?? this.refresh
    );
  }
}

// ------------- events -------------
abstract class CommunityEvent extends Equatable {}

class FetchCommunity extends CommunityEvent {
  final bool refresh;
  FetchCommunity({ this.refresh });
  
  @override
  toString() => "FetchCommunity";
}

// ---- api -----
class GetCommunitiesResult {
  final List<dynamic> communities;
  GetCommunitiesResult({ this.communities });

  factory GetCommunitiesResult.fromJson(Map<String, dynamic> json) {
    return GetCommunitiesResult(communities: json['communities']);
  }
}
