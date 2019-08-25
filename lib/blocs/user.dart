import './conf.dart';
import './utils.dart';
import './verify.dart';
import './article_list.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

/// User 
/// @page: ['/home']
// -------------- bloc ----------------
class UserBloc extends Bloc<UserEvent, UserState> {
  final VerifyBloc verifyBloc;
  StreamSubscription verifyBlocSubscription;
  
  UserBloc(this.verifyBloc) {
    verifyBlocSubscription = verifyBloc.state.listen((state){
        if (state is CodeVerifiedSucceed) {
          this.dispatch(CheckUserEvent());
        } 
    });
  }
  
  @override
  UserState get initialState => Empty();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is CheckUserEvent) {
      String mail = await getString('mail');
      String code = await getString('code');
      var res = await http.post(
        "${conf['url']}/${mail}/verify",
        body: { 'code': code }
      );

      if (res.statusCode == 200) {
        yield UserInited(mail: mail);
      } else {
        yield UserUnInited();
      }
    } else if (event is InitUserEvent) {
      yield UserInited(mail: event.mail);
    } else if (event is LogoutEvent) {
      await clear();
      yield UserUnInited();
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

class LogoutEvent extends UserEvent {
  @override
  String toString() => 'LogoutEvent';
}

// -------------- states ------------------
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class Empty extends UserState {
  @override
  String toString() => 'Empty';
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
