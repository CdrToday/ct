import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/x/req.dart' as xReq;


class UserBloc extends Bloc<UserEvent, UserState> {
  final VerifyBloc v;
  final ProfileBloc p;
  
  UserBloc({this.v, this.p}) {
    v.state.listen((state){
        if (state is CodeVerifiedSucceed) {
          this.dispatch(CheckUserEvent());
        } 
    });

    p.state.listen((state){
        if (state is ProfileUpdatedSucceed) {
          this.dispatch(InitUserEvent(mail: state.mail, name: state.name));
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
    xReq.Requests r = await xReq.Requests.init();

    if (event is CheckUserEvent) {
      String mail = await getString('mail');
      String code = await getString('code');

      if (mail == "" || code == "") {
        yield UserUnInited();
        return;
      }

      var res = await r.authVerify(mail: mail, code: code);
      if (res.statusCode == 200) {
        MailVerifyResult _data = MailVerifyResult.fromJson(json.decode(res.body));
        
        yield UserInited(
          mail: _data.data['mail'],
          name: _data.data['name']
        );
        return;
      } else if (res.statusCode == 408) {
        yield (currentState is UserBlocTimeout)
        ? (currentState as UserBlocTimeout).copyWith(
          times: (currentState as UserBlocTimeout).times + 1
        ) : UserBlocTimeout(times: 0);
        return;
      }

      yield UserUnInited();
    } else if (event is InitUserEvent) {
      yield UserInited(mail: event.mail, name: event.name);
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

class UserBlocTimeout extends UserState {
  final int times;

  UserBlocTimeout({ this.times }) : super([ times ]);
  UserBlocTimeout copyWith({ int times }) {
    return UserBlocTimeout(times: times ?? this.times);
  }
  @override
  String toString() => 'UserBlocTimeout';
}

class UserInited extends UserState {
  final String mail;
  final String name;
  final String avatar;
  
  UserInited({this.mail, this.name, this.avatar});
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

class UpdateUserName extends UserEvent {
  final String name;
  UpdateUserName({ this.name });

  @override
  String toString() => 'UpdateUserName';
}

class LogoutEvent extends UserEvent {
  @override
  String toString() => 'LogoutEvent';
}


// -------------- apis ---------------------
class MailVerifyResult {
  final String msg;
  final Map<String, dynamic> data;
  MailVerifyResult({ this.msg, this.data });

  factory MailVerifyResult.fromJson(Map<String, dynamic> json) {
    return MailVerifyResult( msg: json['msg'], data: json['data']);
  }
}
