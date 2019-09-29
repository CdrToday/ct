import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

// theme bloc
enum ThemeEvent { toggle }

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Colors.grey[50],
    primaryColor: Colors.white,
    primaryColorLight: Colors.grey[100],
    accentColor: Colors.grey[700],
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: Colors.grey[50],
      elevation: 0.0,
    ),
    textTheme: TextTheme(),
    iconTheme: IconThemeData(color: Colors.green),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      )
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black)
      )
    )
  );

  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Colors.grey[50],
    primaryColor: Colors.white,
    primaryColorLight: Colors.grey[100],
    primaryColorDark: Colors.black,
    accentColor: Colors.grey[700],
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: Colors.grey[50],
      elevation: 0.0,
    ),
    textTheme: TextTheme(),
    iconTheme: IconThemeData(color: Colors.green),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))
      )
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black)
      )
    )
  );
  
  @override
  ThemeData get initialState => light;

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.toggle:
        yield currentState == dark ? light : dark;
      break;
    }
  }
}
