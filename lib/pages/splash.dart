import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
        Navigator.of(context).pushReplacementNamed('/init');
    });
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
      body: Container(
        child: Column(
          children: [
            Text(
              'cdr.today',
              style: Theme.of(context).textTheme.display1
            ),
            Divider(),
            Text('Louder than words.', style: TextStyle(color: Colors.grey)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        padding: EdgeInsets.only(
          left: 80.0,
          right: 80.0,
          bottom: 120.0
        )
      )
    );
  }
}
