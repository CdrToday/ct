import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/x/_style/color.dart';

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: sendCode(context, _value),
        backgroundColor: CtColors.tp,
        border: null,
      ),
      child: Input(
        onChanged: changeValue,
        size: 24.0,
        helper: '请输入您的邮箱'
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
            info(context, '邮件发送失败，请重试');
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
              return CupertinoActivityIndicator();
            } else {
              return CtNoRipple(
                icon: Icons.check,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
                  ).hasMatch(_email);
                  
                  if (!emailValid) {
                    info(context, '请输入正确的邮箱');
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
