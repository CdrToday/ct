import './conf.dart';
import './utils.dart';
import './verify.dart';
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
  UserState get initialState => UserEmptyState();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is CheckUserEvent) {
      String mail = await getString('mail');
      String code = await getString('code');

      Map data = {
        'code': code
      };
      
      var res = await http.post(
        "${conf['url']}/${mail}/verify",
        body: json.encode(data)
      );

      if (res.statusCode == 200) {
        MailVerifyResult _data = MailVerifyResult.fromJson(json.decode(res.body));
        
        yield UserInited(
          mail: _data.data['mail'],
          name: _data.data['name']
        );
      } else {
        yield UserUnInited();
      }
    } else if (event is InitUserEvent) {
      yield UserInited(mail: event.mail, name: event.name);
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
  final String name;
  InitUserEvent({ this.mail, this.name });
  
  @override
  String toString() => 'InitUserEvent';
}

class LogoutEvent extends UserEvent {
  @override
  String toString() => 'LogoutEvent';
}

class UpdateUserName extends UserEvent {
  final String name;
  UpdateUserName({ this.name });

  @override
  String toString() => 'UpdateUserName';
}

// -------------- states ------------------
abstract class UserState extends Equatable {
  UserState([List props = const []]) : super(props);
}

class UserUnInited extends UserState {
  @override
  String toString() => 'UserUnInited';
}

class UserEmptyState extends UserState {
  @override
  String toString() => 'UserEmptyState';
}

class UserInited extends UserState {
  final String mail;
  final String name;
  
  UserInited({
      this.mail, this.name
  }) : super([ mail, name ]);
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
