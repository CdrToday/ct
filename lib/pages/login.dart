import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  
  void changeValue(String value) {
    setState(() { _value = value; });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ sendCode(context, _value)],
      ),
      body: Container(
        child: TextField(
          onChanged: changeValue,
          decoration: InputDecoration(hintText: '邮箱'),
          style: Theme.of(context).textTheme.headline,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        padding: EdgeInsets.only(
          left: kToolbarHeight / 2,
          right: kToolbarHeight / 2,
          bottom: kToolbarHeight * 2
        ),
        alignment: Alignment.center,
        height: double.infinity,
      ),
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
            Navigator.pushNamed(context, '/user/verify');
          }
        },
        child: BlocBuilder<VerifyBloc, VerifyState>(
          builder: (context, state) {
            if (state is CodeSending) {
              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CupertinoActivityIndicator(),
              );
            } else {
              return IconButton(
                icon: Icon(Icons.check),
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
              );
            }
          }
        ),
      ),
    ),
  );
}
