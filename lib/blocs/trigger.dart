import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';

class TriggerBloc extends Bloc<TriggerEvent, TriggerState> {
  @override
  Stream<TriggerState> transform(
    Stream<TriggerEvent> events,
    Stream<TriggerState> Function(TriggerEvent event) next,
  ) {
    return super.transform(
      (events as Observable<TriggerEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  TriggerState get initialState => TriggerIncipency();

  @override
  Stream<TriggerState> mapEventToState(TriggerEvent event) async* {
    if (event is QuitCommunityTrigger) {
      yield QuitCommunity();
      yield TriggerIncipency();
    }
  }
}

// -------------- states ------------------
abstract class TriggerState extends Equatable {
  TriggerState([List props = const []]) : super(props);
}

class TriggerIncipency extends TriggerState {
  @override
  String toString() => 'TriggerIncipency';
}

class QuitCommunity extends TriggerState {
  @override
  String toString() => 'QuitCommunity';
}

// -------------- events ----------------
abstract class TriggerEvent extends Equatable {}

class QuitCommunityTrigger extends TriggerEvent {
  @override
  String toString() => 'QuitCommunityTrigger';
}
