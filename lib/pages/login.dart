import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  Login({ Key key }) : super(key: key);
  
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _value = '';
  bool checked = false;
  
  void changeValue(String value) {
    setState(() { _value = value; });
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: checked? sendCode(context, _value): SizedBox(),
        backgroundColor: CtColors.tp,
        border: null,
      ),
      child: Column(
        children: [
          SizedBox(),
          Container(
            child: Input(
              onChanged: changeValue,
              size: 24.0,
              helper: '请输入您的邮箱'
            ),
            padding: EdgeInsets.only(top: 50),
          ),
          Container(
            child: Row(
              children: [
                Material(
                  child: Checkbox(
                    value: checked,
                    activeColor: CtColors.gray6,
                    onChanged: (value) {
                      setState(() {
                          checked = value;
                      });
                    }
                  ),
                  color: Colors.transparent
                ),
                Text('同意'),
                GestureDetector(
                  child: Text(
                    '《用户条款》',
                    style: TextStyle(
                      color: CtColors.blue
                    )
                  ),
                  onTap: () => Navigator.of(
                    context, rootNavigator: true
                  ).pushNamed('/protocol')
                ),
                Text('与'),
                GestureDetector(
                  child: Text(
                    '《隐私政策》',
                    style: TextStyle(
                      color: CtColors.blue
                    )
                  ),
                  onTap: () async {
                    var url = 'https://cdr-today.github.io/intro/privacy/zh.html';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center
            ),
            padding: EdgeInsets.only(bottom: 50),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween
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
