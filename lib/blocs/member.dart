import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;

Future<List<dynamic>> getMembers({String id}) async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.getMembers(id: id);
  return jsonDecode(res.body)['members'];
}

// ------- bloc -----
class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final UserBloc u;
  final CommunityBloc c;
  
  MemberBloc({ this.c, this.u }) {
    c.state.listen((state) {
        if (state is Communities) {
          if (
            state.current != '' &&
            state.current != null
          ) this.dispatch(FetchMember(id: state.current));
        }
    });

    u.state.listen(
      (state) {
        if (
          (state is UserInited) && state.local
        ) this.dispatch(FetchMember(id: (currentState as Members).id));
      }
    );
  }
  
  @override
  Stream<MemberState> transform(
    Stream<MemberEvent> events,
    Stream<MemberState> Function(MemberEvent event) next,
  ) {
    return super.transform(
      (events as Observable<MemberEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  MemberState get initialState => Members(
    id: '',
    members: [],
    refresh: 0,
  );

  @override
  Stream<MemberState> mapEventToState(MemberEvent event) async* {
    if (event is FetchMember) {
      var members = await getMembers(id: event.id);
      yield (currentState as Members).copyWith(
        id: event.id,
        members: members,
        refresh: (currentState as Members).refresh + 1,
      );
    }
  }
}

// ------------- state ------------
abstract class MemberState extends Equatable {
  MemberState([List props = const []]) : super(props);
}

class Members extends MemberState {
  final List<dynamic> members;
  final int refresh;
  final String id;
  
  Members({
      this.id = '', this.members, this.refresh = 0,
  }) : super([ id, members, refresh ]);

  Members copyWith({
      List<dynamic> members, int refresh, String id,
  }) {
    return Members(
      id: id ?? this.id,
      members: members ?? this.members,
      refresh: refresh ?? this.refresh
    );
  }
}

// ------------- events -------------
abstract class MemberEvent extends Equatable {}

class FetchMember extends MemberEvent {
  final String id;
  FetchMember({ this.id });
  
  @override
  toString() => "FetchMember";
}
