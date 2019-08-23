import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/verify.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:atlas/navigations/args.dart';

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
      appBar: AppBar(title: Text('登录')),
      body: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Center(
                  child: Text(
                    'cdr.today',
                    style: Theme.of(context).textTheme.display2
                  )
                ),
                padding: EdgeInsets.only(top: 75.0, bottom: 35.0)
              ),
              TextField(
                onChanged: changeValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '邮箱',
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: Center(child: sendCode(context, _value))
              )
            ]
          )
        ),
      )
    );
  }
}



sendCode(BuildContext context, String _email) {
  final VerifyBloc _bloc = BlocProvider.of<VerifyBloc>(context);
  
  return RaisedButton(
    onPressed: () {
      bool emailValid = RegExp(
        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
      ).hasMatch(_email);
      
      if (!emailValid) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('请输入正确的邮箱'),
          ),
        );
      } else {
        _bloc.dispatch(SendCodeEvent(mail: _email));
      }
    },
    child: BlocListener<VerifyBloc, VerifyState>(
      listener: (context, state) {
        if (state is CodeSentFailed) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('邮件发送失败，请重试'),
            ),
          );
        } else if (state is CodeSentSucceed) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text('请查收验证邮件'),
            ),
          );
        }
      },
      child: BlocBuilder<VerifyBloc, VerifyState>(
        builder: (context, state) {
          if (state is CodeSending) {
            return CircularProgressIndicator();
          } else {
            return Text(
              '发送验证码',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white
              )
            );
          }
        }
      )
    ),
    color: Theme.of(context).primaryColor
  );
}
