import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/community.dart';

// ------- bloc -----
class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  final CommunityBloc c;
  DrawerBloc({ this.c }) {
    c.state.listen((state) {
        if (state is CommunityFetchedSucceed) {
          if (state.current == '') {
            this.dispatch(NoSwipeDrawerEvent());
            return;
          }
          this.dispatch(ChangeDrawerIndex(index: 0));
        }
    });
  }
  
  @override
  DrawerState get initialState => DrawerIndex(index: 0);

  @override
  Stream<DrawerState> mapEventToState(DrawerEvent event) async* {
    if (event is ChangeDrawerIndex) {
      yield DrawerIndex(index: event.index);
    } else if (event is NoSwipeDrawerEvent) {
      yield NoSwipeDrawer();
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

class NoSwipeDrawer extends DrawerState {
  @override
  toString() => 'NoSwipeDrawer';
}

// ------------- events -------------
abstract class DrawerEvent extends Equatable {}

class ChangeDrawerIndex extends DrawerEvent {
  final int index;
  ChangeDrawerIndex({ this.index });
  
  @override
  toString() => 'ChangeDrawerIndex';
}

class NoSwipeDrawerEvent extends DrawerEvent {
  @override
  toString() => 'NoSwipeDrawerEvent';
}
