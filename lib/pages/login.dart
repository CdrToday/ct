import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/navigations/args.dart';

class Login extends StatefulWidget {
  Login({ Key key }) : super(key: key);
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _value = '';
  String _code = '';
  int _time = 60;
  
  void changeValue(String value) {
    setState(() { _value = value; });
  }

  void changeCode(String value) {
    setState(() { _code = value; });
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('登录'),
          automaticallyImplyLeading: false
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text(
                'cdr.today',
                style: Theme.of(context).textTheme.display3
              ),
              SizedBox(height: 80.0),
              TextField(
                onChanged: changeValue,
                decoration: InputDecoration(hintText: '邮箱'),
                style: Theme.of(context).textTheme.title,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 60.0),
              sendCode(context, _value),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          margin: EdgeInsets.symmetric(horizontal: kToolbarHeight),
        ),
      ),
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
    );
  }
}

sendCode(BuildContext context, String _email) {
  final VerifyBloc _bloc = BlocProvider.of<VerifyBloc>(context);
  
  return Builder(
    builder: (context) => Container(
      child: BlocListener<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is CodeSentFailed) {
            snacker(context, '邮件发送失败，请重试');
          } else if (state is CodeSentSucceed) {
            snacker(context, '邮件发送成功，请查收', color: Colors.black);
            new Observable.timer(
              "hi", new Duration(seconds: 1)
            ).listen((i) {
                Navigator.pushNamed(
                  context, '/user/verify',
                  arguments: MailArgs(mail: _email)
                );
              }
            );
          }
        },
        child: BlocBuilder<VerifyBloc, VerifyState>(
          builder: (context, state) {
            if (state is CodeSending) {
              return CircularProgressIndicator();
            } else {
              return OutlineButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                  ).hasMatch(_email);
                  
                  if (!emailValid) {
                    snacker(context, '请输入正确的邮箱');
                  } else {
                    _bloc.dispatch(SendCodeEvent(mail: _email));
                  }
                },
                child: Text("发送验证码", style: TextStyle(fontSize: 16)),
                color: Theme.of(context).primaryColor,
              );
            }
          }
        ),
      ),
    ),
  );
}
