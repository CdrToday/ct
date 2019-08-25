import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
// blocs
import 'package:cdr_today/blocs/main.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/verify.dart';
import 'package:cdr_today/blocs/article_list.dart';
// pages
import 'package:cdr_today/pages/login.dart';
import 'package:cdr_today/pages/verify.dart';
import 'package:cdr_today/pages/edit.dart';
import 'package:cdr_today/pages/article.dart';
import 'package:cdr_today/pages/modify.dart';
import 'package:cdr_today/pages/version.dart';
import 'package:cdr_today/pages/splash.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/navigations/tabbar.dart';

/* app */
void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  VerifyBloc verifyBloc = VerifyBloc();
  
  @override
  Widget build(BuildContext context) {
    VerifyBloc verifyBloc = VerifyBloc();
    ArticleListBloc articleListBloc = ArticleListBloc();
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          builder: (context) => ThemeBloc()
        ),
        BlocProvider<EditBloc>(
          builder: (context) => EditBloc()
        ),
        BlocProvider<VerifyBloc>(
          builder: (context) => verifyBloc
        ),
        BlocProvider<ArticleListBloc>(
          builder: (context) => articleListBloc
        ),
        BlocProvider<UserBloc>(
          builder: (context) => UserBloc(verifyBloc)
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, theme) => app(context, theme)
      )
    );
  }
}

Widget app(BuildContext context, ThemeData theme) {  
  return MaterialApp(
    theme: theme,
    initialRoute: '/',
    onGenerateRoute: router,
    home: SplashPage()
  );
}

/* app router */
MaterialPageRoute router(settings) {
  String r = settings.name;
  
  if (r == '/init') {
    final RootArgs args = settings.arguments;
    int index = 0;
    if (args != null) {
      index = args.index;
    }
    
    return MaterialPageRoute(
      builder: (context) =>  BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserUnInited) {
            return Login();
          } else if (state is UserInited) {
            return TabNavigator(index: index);
          } else {
            final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
            _userBloc.dispatch(CheckUserEvent());
            return Login();
          }
        }
      )
    );
  } else if (r == '/user/verify') {
    final MailArgs args = settings.arguments;
    return MaterialPageRoute(
      builder: (context) =>  Verify(mail: args.mail)
    );
  } else if (r == '/user/edit') {
    return MaterialPageRoute(
      builder: (context) =>  Edit()
    );
  } else if (r == '/article') {
    final ArticleArgs args = settings.arguments;
    return MaterialPageRoute(
      builder: (context) => Article(args: args)
    );
  } else if (r == '/mine/modify') {
    final ModifyArgs args = settings.arguments;
    return MaterialPageRoute(
      builder: (context) => Modify(args: args)
    );
  } else if (r == '/mine/version') {
    return MaterialPageRoute(
      builder: (context) => VersionPage()
    );
  }
  
  
  return MaterialPageRoute(
    builder: (context) =>  Text('hello')
  );
}
