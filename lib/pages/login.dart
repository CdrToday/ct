import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('登录'),
          automaticallyImplyLeading: false
        ),
        body: Builder(
          builder: (context) => Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 150.0),
                Text(
                  'cdr.today',
                  style: Theme.of(context).textTheme.display2
                ),
                SizedBox(height: 84.0),
                TextField(
                  onChanged: changeValue,
                  decoration: InputDecoration(hintText: '邮箱'),
                  style: Theme.of(context).textTheme.title,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 42.0),
                sendCode(context, _value),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            margin: EdgeInsets.symmetric(horizontal: kToolbarHeight)
          ),
        ),
      ),
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
    );
  }
}

sendCode(BuildContext context, String _email) {
  final VerifyBloc _bloc = BlocProvider.of<VerifyBloc>(context);
  
  return Container(
    child: BlocListener<VerifyBloc, VerifyState>(
      listener: (context, state) {
        if (state is CodeSentFailed) {
          snacker(context, '邮件发送失败，请重试');
        } else if (state is CodeSentSucceed) {
          Navigator.pushNamed(
            context, '/user/verify',
            arguments: MailArgs(mail: _email)
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
              child: Text('发送验证码', style: TextStyle(fontSize: 16)),
              color: Theme.of(context).primaryColor,
            );
          }
        }
      ),
    ),
  );
}
