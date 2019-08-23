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
      var res = await http.post("${conf['url']}/${event.mail}/code");
      yield CodeSending();
      if (res.statusCode == 200) {
        yield CodeSentSucceed();
      } else {
        yield CodeSentFailed();
      }
      return;
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

class CodeSentSucceed extends VerifyState {
  @override
  String toString() => 'CodeSentSucceed';
}

class CodeSentFailed extends VerifyState {
  @override
  String toString() => 'CodeSentFailed';
}
