import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/community.dart';

// ------- bloc -----
class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  
  @override
  DrawerState get initialState => DrawerIndex(index: 0);

  @override
  Stream<DrawerState> mapEventToState(DrawerEvent event) async* {
    if (event is ChangeDrawerIndex) {
      yield DrawerIndex(index: event.index);
    }
  }
}

// ------------- state ------------
abstract class DrawerState extends Equatable {
  // final int index;
  DrawerState([List props = const []]) : super(props);
}

class DrawerIndex extends DrawerState {
  final int index;
  DrawerIndex({ this.index }) : super([index]);
  
  @override
  toString() => 'DrawerIndex';
}

// ------------- events -------------
abstract class DrawerEvent extends Equatable {}

class ChangeDrawerIndex extends DrawerEvent {
  final int index;
  ChangeDrawerIndex({ this.index });
  
  @override
  toString() => 'ChangeDrawerIndex';
}
