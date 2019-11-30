import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/store.dart' as store;

class DbBloc extends Bloc<DbEvent, DbState> {
  final UserBloc u;
  
  // @override
  // Stream<DbState> transform(
  //   Stream<DbEvent> events,
  //   Stream<DbState> Function(DbEvent event) next,
  // ) {
  //   return super.transform(
  //     (events as Observable<DbEvent>).debounceTime(
  //       Duration(milliseconds: 500),
  //     ), next
  //   );
  // }

  DbBloc({ this.u }) {
    u.state.listen(
      (state) {
        if ((state is UserInited)) {
          this.dispatch(DbRefresh());
        }
      }
    );
  }

  Stream<DbState> mapEventToState(DbEvent event) async* {
    var db = store.CtDatabase();
    await db.open();
    
    var settings;
    
    if (event is DbRefresh) {
      settings = await db.getSettings();
      yield (currentState as Db).copyWith(
        longArticle: settings['longArticle'] == 'true'? true: false
      );
    }
  }

  @override
  DbState get initialState => Db(
    longArticle: false,
  );
}

///@state
abstract class DbState extends Equatable {
  DbState([List props = const []]) : super(props);
}

class Db extends DbState {
  final bool longArticle;
  
  Db({
      this.longArticle,
  }): super([
      longArticle,
  ]);
  
  Db copyWith({ bool longArticle}) {
    return Db(
      longArticle: longArticle ?? this.longArticle,
    );
  }
}

///@event
abstract class DbEvent extends Equatable {}

class DbRefresh extends DbEvent {
  @override
  toString() => "DbInit";
}
