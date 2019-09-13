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

ThemeData light() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey[50],
    primaryColor: Colors.white,
    primaryColorLight: Colors.grey[200],
    accentColor: Colors.grey[700],
    splashColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      color: Colors.grey[200],
      elevation: 0.5,
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
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Color(0xffeeeeee),
    appBarTheme: AppBarTheme(
      color: Colors.grey,
      elevation: 0.0,
    ),
    iconTheme: IconThemeData(color: Colors.green)
  );
  
  @override
  ThemeData get initialState => light;

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    switch (event) {
      case ThemeEvent.toggle:
        yield currentState == ThemeData.dark()
        ? light
        : ThemeData.dark();
      break;
    }
  }
}
