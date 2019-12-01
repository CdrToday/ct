import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/store.dart' as store;

class DbBloc extends Bloc<DbEvent, DbState> {
  final UserBloc u;
  final CommunityBloc c;

  DbBloc({ this.u, this.c }) {
    u.state.listen(
      (state) {
        if ((state is UserInited)) {
          this.dispatch(DbRefresh());
        }
      }
    );

    c.state.listen(
      (state) async {
        if (state is Communities) {
          if (state.refresh == -1) {
            var db = store.CtDatabase();
            await db.open();
            await db.refreshCommunity(state.current);
          }
        }
      }
    );
  }

  Stream<DbState> mapEventToState(DbEvent event) async* {
    var db = store.CtDatabase();
    await db.open();
    
    var settings;
    var communities;
    
    if (event is DbRefresh) {
      settings = await db.getSettings();
      communities = await db.getCommunities();

      yield (currentState as Db).copyWith(
        longArticle: settings['longArticle'] == 'true'? true: false,
        communities: communities,
      );
    }
  }

  @override
  DbState get initialState => Db(
    longArticle: false,
    communities: {},
  );
}

///@state
abstract class DbState extends Equatable {
  DbState([List props = const []]) : super(props);
}

class Db extends DbState {
  final bool longArticle;
  final Map communities;
  
  Db({
      this.longArticle,
      this.communities,
  }): super([
      longArticle,
      communities,
  ]);
  
  Db copyWith({
      bool longArticle,
      Map communities,
  }) {
    return Db(
      longArticle: longArticle ?? this.longArticle,
      communities: communities ?? this.communities,
    );
  }
}

///@event
abstract class DbEvent extends Equatable {}

class DbRefresh extends DbEvent {
  @override
  toString() => "DbInit";
}
