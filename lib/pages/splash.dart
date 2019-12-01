import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/style.dart';
import 'package:cdr_today/x/conf.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {});
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  
  Widget build(context) {
    final _bloc = BlocProvider.of<UserBloc>(context);
    _bloc.dispatch(CheckUserEvent());
    
    return CupertinoPageScaffold(
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is! SplashState) {
            Navigator.of(context).pushReplacementNamed('/init');
          }
        },
        child: Center(
          child: Text(
            conf['name'],
            textAlign: TextAlign.center,
            style: CtTextStyle.largeTitle
          ),
        )
      )
    );
  }
}
