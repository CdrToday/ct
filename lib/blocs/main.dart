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
  final ThemeData light = ThemeData(
    scaffoldBackgroundColor: Color(0xffeeeeee),
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
