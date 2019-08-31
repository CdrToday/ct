import './conf.dart';
import './utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

// --------------- bloc ---------------
class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  @override
  VerifyState get initialState => UnVerified();

  @override
  Stream<VerifyState> mapEventToState(VerifyEvent event) async* {
    if (event is SendCodeEvent) {
      yield CodeSending();
      var res = await http.post("${conf['url']}/${event.mail}/code");
      
      if (res.statusCode == 200) {
        yield CodeSentSucceed();
      } else {
        yield CodeSentFailed();
      }
      return;
    } else if (event is VerifyCodeEvent) {
      yield CodeSending();

      Map data = {
        'code': event.code
      };
      
      var res = await http.post(
        "${conf['url']}/${event.mail}/verify",
        body: json.encode(data)
      );
      
      if (res.statusCode == 200) {
        await setString('mail', event.mail);
        await setString('code', event.code);
        yield CodeVerifiedSucceed();
      } else {
        yield CodeVerifiedFailed();
      }
    }
    return;
  }
}

// --------------- events ----------------
abstract class VerifyEvent extends Equatable {}

class SendCodeEvent extends VerifyEvent {
  final String mail;
  SendCodeEvent({ this.mail });
  
  @override
  String toString() => 'SendCodeEvent';
}

class VerifyCodeEvent extends VerifyEvent {
  final String mail;
  final String code;
  VerifyCodeEvent({ this.mail, this.code });
  
  @override
  String toString() => 'VerifyCodeEvent';
}

// ---------------- state ------------------
abstract class VerifyState extends Equatable {
  VerifyState([List props = const []]) : super(props);
}

class UnVerified extends VerifyState {
  @override
  String toString() => 'UnVerified';
}

class CodeSending extends VerifyState {
  @override
  String toString() => 'CodeSending';
}

class CodeSentFailed extends VerifyState {
  @override
  String toString() => 'CodeSentFailed';
}

class CodeSentSucceed extends VerifyState {
  @override
  String toString() => 'CodeSentSucceed';
}

class CodeVerifiedSucceed extends VerifyState {
  @override
  String toString() => 'CodeVerifiedSucceed';
}

class CodeVerifiedFailed extends VerifyState {
  @override
  String toString() => 'CodeVerifiedFailed';
}
