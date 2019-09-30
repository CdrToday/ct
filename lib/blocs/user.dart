import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/x/req.dart' as xReq;


Future<Map<String, String>> checkUser({String mail, String code}) async {
  final xReq.Requests r = await xReq.Requests.init();
  var res = await r.authVerify(mail: mail, code: code);
  if (res.statusCode == 400) return { "err": "400" };
  if (res.statusCode == 408) return checkUser(mail: mail, code: code);

  var data = json.decode(res.body)['data'];
  return {
    'name': data['name'],
    'mail': data['mail'],
    'avatar': data['avatar'],
  };
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final VerifyBloc v;
  
  UserBloc({this.v}) {
    v.state.listen((state){
        if (state is CodeSentSucceed) {
          if (state.created) this.dispatch(CheckUserEvent());
        } else if (state is CodeVerifiedSucceed) {
          this.dispatch(CheckUserEvent());
        } 
    });
  }

  @override
  Stream<UserState> transform(
    Stream<UserEvent> events,
    Stream<UserState> Function(UserEvent event) next,
  ) {
    return super.transform(
      (events as Observable<UserEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  UserState get initialState => SplashState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is CheckUserEvent) {
      String mail = await getString('mail');
      String code = await getString('code');

      if (mail == "" || code == "") {
        yield UserUnInited();
        return;
      }

      var data = await checkUser(mail: mail, code:code);
      if (data['err'] != null) {
        yield UserUnInited();
        return;
      }
      
      yield (currentState is UserInited) ? (currentState as UserInited).copyWith(
        mail: data['mail'],
        name: data['name'],
        avatar: data['avatar'],
        refresh: (currentState as UserInited).refresh + 1
      ):UserInited(
        mail: data['mail'],
        name: data['name'],
        avatar: data['avatar'],
        refresh: 0,
      );
    } else if (event is InitUserEvent) {
      yield (currentState as UserInited).copyWith(
        mail: event.mail,
        name: event.name,
        avatar: event.avatar,
      );
    } else if (event is LogoutEvent) {
      clear();
      yield UserUnInited();
    }
    return;
  }
}

// -------------- states ------------------
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class SplashState extends UserState {
  @override
  String toString() => 'SplashState';
}

class UserUnInited extends UserState {
  @override
  String toString() => 'UserUnInited';
}

class UserInited extends UserState {
  final String mail;
  final String name;
  final String avatar;
  final int refresh;
  
  UserInited({
      this.mail,
      this.name,
      this.avatar,
      this.refresh,
  }) : super([ mail, name, avatar, refresh ]);

  UserInited copyWith({
      String mail,
      String name,
      String avatar,
      int refresh,
  }) {
    return UserInited(
      mail: mail ?? this.mail,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      refresh: refresh ?? this.refresh,
    );
  }
}


// -------------- events ----------------
abstract class UserEvent extends Equatable {}

class CheckUserEvent extends UserEvent {
  @override
  String toString() => 'CheckUserEvent';
}

class InitUserEvent extends UserEvent {
  final String mail;
  final String name;
  final String avatar;
  InitUserEvent({ this.mail, this.name, this.avatar });
  
  @override
  String toString() => 'InitUserEvent';
}

class LogoutEvent extends UserEvent {
  @override
  String toString() => 'LogoutEvent';
}
