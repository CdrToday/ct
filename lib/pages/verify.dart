import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/auth.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/x/_style/color.dart';

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        trailing: verifyCode(context, _value),
        border: null,
        backgroundColor: CtColors.tp
      ),
      child: Input(
        onChanged: changeValue,
        size: 24.0,
        helper: '请输入您的验证码'
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
            info(context, '邮箱验证失败，请重试');
          } else if (state is CodeVerifiedSucceed) {
            Navigator.pushNamedAndRemoveUntil(context, '/root', (_) => false);
          }
        },
        child: BlocBuilder<VerifyBloc, VerifyState>(
          builder: (context, state) {
            if (state is CodeVerifying) {
              return CupertinoActivityIndicator();
            } else {
              return CtNoRipple(
                icon: Icons.check,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  bool codeValid = RegExp(
                    r"^[a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12}$"
                  ).hasMatch(_code);
                  
                  if (!codeValid) {
                    info(
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
