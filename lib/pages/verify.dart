import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/snackers.dart';

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
        appBar: AppBar(
          title: Text('验证邮箱'),
          leading: CloseButton(),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text(
                'cdr.today',
                style: Theme.of(context).textTheme.display2
              ),
              SizedBox(height: 80.0),
              TextField(
                onChanged: changeValue,
                decoration: InputDecoration(hintText: '验证码'),
                style: Theme.of(context).textTheme.title
              ),
              SizedBox(height: 60.0),
              verifyCode(context, _value)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          margin: EdgeInsets.only(
            left: kToolbarHeight,
            right: kToolbarHeight,
            bottom: kToolbarHeight * 2
          )
        ),
      ),
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
    );
  }
}

verifyCode(BuildContext context, String _code) {
  final VerifyBloc _bloc = BlocProvider.of<VerifyBloc>(context);
  
  return Builder(
    builder: (context) => Container(
      child: BlocListener<VerifyBloc, VerifyState>(
        listener: (context, state) {
          if (state is CodeVerifiedFailed) {
            snacker(context, '邮箱验证失败，请重试');
          } else if (state is CodeVerifiedSucceed) {
            Navigator.pushNamedAndRemoveUntil(context, '/root', (_) => false);
          }
        },
        child: BlocBuilder<VerifyBloc, VerifyState>(
          builder: (context, state) {
            if (state is CodeVerifying) {
              return CircularProgressIndicator();
            } else {
              return OutlineButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  bool codeValid = RegExp(
                    r"^[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}$"
                  ).hasMatch(_code);
                  
                  if (!codeValid) {
                    snacker(
                      context, "请输入正确的验证码，如: '99293e8e-5629-40d3-8747-10016474d49c'"
                    );
                  } else {
                    _bloc.dispatch(VerifyCodeEvent(code: _code));
                  }
                },
                child: Text('验证邮箱', style: TextStyle(fontSize: 16)),
                color: Theme.of(context).primaryColor,
              );
            }
          }
        ),
      ),
    ),
  );
}
