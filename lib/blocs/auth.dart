import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// --------------- bloc ---------------
class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  @override
  Stream<VerifyState> transform(
    Stream<VerifyEvent> events,
    Stream<VerifyState> Function(VerifyEvent event) next,
  ) {
    return super.transform(
      (events as Observable<VerifyEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  VerifyState get initialState => UnVerified();

  @override
  Stream<VerifyState> mapEventToState(VerifyEvent event) async* {
    xReq.Requests r = xReq.Requests();
    
    if (event is SendCodeEvent) {
      yield CodeSending();
      var res = await r.auth(mail: event.mail);
      
      if (res.statusCode == 200) {
        yield CodeSentSucceed(mail: event.mail);
      } else {
        yield CodeSentFailed();
      }
    } else if (event is VerifyCodeEvent) {
      String mail;
      if (currentState is CodeSentSucceed) {
        mail = (currentState as CodeSentSucceed).mail;
      } else if (currentState is CodeVerifiedFailed) {
        mail = (currentState as CodeVerifiedFailed).mail;
      }
      
      yield CodeVerifying(mail: mail);
      var res = await r.authVerify(mail: mail, code: event.code);
      
      if (res.statusCode == 200) {
        yield CodeVerifiedSucceed();
      } else {
        yield CodeVerifiedFailed(mail: mail);
      }
    }
  }
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
  final String mail;
  CodeSending({ this.mail });
  
  @override
  String toString() => 'CodeSending';
}

class CodeVerifying extends VerifyState {
  final String mail;
  CodeVerifying({ this.mail });
  
  @override
  String toString() => 'CodeSending';
}

class CodeSentFailed extends VerifyState {
  @override
  String toString() => 'CodeSentFailed';
}

class CodeSentSucceed extends VerifyState {
  final String mail;
  CodeSentSucceed({ this.mail });
  
  @override
  String toString() => 'CodeSentSucceed';
}

class CodeVerifiedSucceed extends VerifyState {
  @override
  String toString() => 'CodeVerifiedSucceed';
}

class CodeVerifiedFailed extends VerifyState {
  final String mail;
  CodeVerifiedFailed({ this.mail });

  @override
  String toString() => 'CodeVerifiedFailed';
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
  final String code;
  VerifyCodeEvent({ this.code });
  
  @override
  String toString() => 'VerifyCodeEvent';
}
