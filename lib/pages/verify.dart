import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/snackers.dart';

class Verify extends StatefulWidget {
  Verify({ Key key }) : super(key: key);
  
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  String _value = '';
  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: [verifyCode(context, _value)]
      ),
      body: Container(
        child: TextField(
          onChanged: changeValue,
          decoration: InputDecoration(
            hintText: '验证码',
            helperText: '请输入您的验证码',
            helperStyle: TextStyle(fontSize: 16.0)
          ),
          style: TextStyle(fontSize: 24.0),
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
              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: CupertinoActivityIndicator(),
              );
            } else {
              return IconButton(
                icon: Icon(Icons.check),
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
              );
            }
          }
        ),
      ),
    ),
  );
}
