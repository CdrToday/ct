
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/widgets/buttons.dart';

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
        leading: null,
      ),
      body: Container(
        child: TextField(
          onChanged: changeValue,
          decoration: InputDecoration(
            hintText: '邮箱',
            helperText: '请输入您的邮箱',
            helperStyle: TextStyle(fontSize: 16.0)
          ),
          style: TextStyle(
            fontSize: 24.0,
          ),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
        ),
        padding: EdgeInsets.only(
          left: kToolbarHeight / 2,
          right: kToolbarHeight / 2,
          bottom: kToolbarHeight / 3
        ),
        alignment: Alignment.center,
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
            if (state.created) {
              Navigator.pushNamed(context, '/root');
              return;
            }
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
              return NoRipple(
                icon: Icon(Icons.check),
                onTap: () {
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
