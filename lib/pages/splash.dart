import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';

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
    
    return Scaffold(
      appBar: null,
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is! SplashState) {
            Navigator.of(context).pushReplacementNamed('/init');
          }
        },
        child: Container(
          child: Column(
            children: [
              Spacer(),
              Text(
                'cdr.today',
                style: Theme.of(context).textTheme.display2,
                textAlign: TextAlign.center
              ),
              Spacer(),
              Text(
                'Louder than Words.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
          padding: EdgeInsets.only(bottom: kToolbarHeight)
        ),
      ),
    );
  }
}
