import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
// blocs
import 'package:cdr_today/blocs/main.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/verify.dart';
// pages
import 'package:cdr_today/pages/login.dart';
import 'package:cdr_today/navigations/args.dart';

/* app */
void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  UserBloc userBloc = UserBloc();
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          builder: (context) => ThemeBloc()
        ),
        BlocProvider<UserBloc>(
          builder: (context) => UserBloc()
        ),
        BlocProvider<VerifyBloc>(
          builder: (context) => VerifyBloc()
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) => app(context, theme)
      )
    );
  }
}

Widget app(BuildContext context, ThemeData theme) {
  final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  
  return MaterialApp(
    theme: theme,
    initialRoute: '/',
    onGenerateRoute: router,
    home: BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserUnInited) {
          _userBloc.dispatch(CheckUserEvent());
          return Login();
        } else if (state is UserInited) {
          return Text('world');
        }
      }
    )
  );
}

/* app router */
MaterialPageRoute router(settings) {
  String r = settings.name;
  if (r == '/init') {
    final RootArgs args = settings.arguments;
    return MaterialPageRoute(
        builder: (context) =>  Text('hello')
    );
  }
  
  return MaterialPageRoute(
    builder: (context) =>  Text('hello')
  );  
}
