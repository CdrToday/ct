import './conf.dart';
import './utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

/// User 
/// @page: ['/home']
// -------------- bloc ----------------
class UserBloc extends Bloc<UserEvent, UserState> {
  @override
  UserState get initialState => UserUnInited();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is CheckUserEvent) {
      String mail = await getString('mail');

      if (mail == '') {
        return;
      } else {
        yield UserInited(mail: mail);
        return;
      }
    } else if (event is InitUserEvent) {
      yield UserInited(mail: event.mail);
      return;
    }
    return;
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
  InitUserEvent({ this.mail });
  
  @override
  String toString() => 'InitUserEvent';
}

// -------------- states ------------------
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class UserUnInited extends UserState {
  @override
  String toString() => 'UserUnInited';
}

class UserInited extends UserState {
  final String mail;
  
  UserInited({
      this.mail,
  }) : super([ mail ]);
}


// -------------- apis ---------------------
class MailVerifyResult {
  final String msg;
  MailVerifyResult({ this.msg });

  factory MailVerifyResult.fromJson(Map<String, String> json) {
    return MailVerifyResult( msg: json['msg']);
  }
}
