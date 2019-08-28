import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/verify.dart';

class Verify extends StatefulWidget {
  final String mail;
  Verify({ Key key, this.mail }) : super(key: key);
  
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  String _value = '';
  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(title: Text('验证邮箱')),
        body: Builder(
          builder: (context) => Container(
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
                  margin: EdgeInsets.only(bottom: 35.0),
                ),
                TextField(
                  onChanged: changeValue,
                  decoration: InputDecoration(hintText: '验证码'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: Center(child: sendCode(context, _value, widget.mail))
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            margin: EdgeInsets.only(left: 50.0, right: 50.0),
            transform: Matrix4.translationValues(0.0, -120.0, 0.0),
          ),
        ),
        // TODO
        resizeToAvoidBottomInset: false
      ),
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
    );
  }
}

sendCode(BuildContext context, String _code, String mail) {
  final VerifyBloc _bloc = BlocProvider.of<VerifyBloc>(context);
  
  return Container(
    child: BlocListener<VerifyBloc, VerifyState>(
      listener: (context, state) {
        if (state is CodeVerifiedFailed) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('邮箱验证失败，请重试'),
            ),
          );
        } else if (state is CodeVerifiedSucceed) {
          Navigator.pushNamedAndRemoveUntil(context, '/root', (_) => false);
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
                bool codeValid = RegExp(
                  r"^[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}"
                ).hasMatch(_code);
                
                if (!codeValid) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        "请输入正确的验证码，如: '99293e8e-5629-40d3-8747-10016474d49c'"
                      ),
                    ),
                  );
                } else {
                  _bloc.dispatch(VerifyCodeEvent(mail: mail, code: _code));
                }
              },
              child: Text(
                '验证邮箱',
                style: TextStyle(fontSize: 16)
              ),
              color: Theme.of(context).primaryColor,
            );
          }
        }
      ),
    ),
  );
}
