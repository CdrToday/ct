import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/reddit.dart';
import 'package:cdr_today/blocs/community.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  final RedditBloc r;
  final CommunityBloc c;
  
  RefreshBloc({ this.c, this.r }) {
    c.state.listen((state) {
        if (state is Communities) {
          if (state.refresh == 0) return;
          this.dispatch(CommunityRefresh(refresh: false));
        }
    });
  }
  
  @override
  Stream<RefreshState> transform(
    Stream<RefreshEvent> events,
    Stream<RefreshState> Function(RefreshEvent event) next,
  ) {
    return super.transform(
      (events as Observable<RefreshEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  RefreshState get initialState => Refresher(
    qr: false,
    edit: false,
    common: false,
    profile: false,
    community: false,
  );

  @override
  Stream<RefreshState> mapEventToState(RefreshEvent event) async* {
    if (event is CommunityRefresh) {
      yield (currentState as Refresher).copyWith(
        community: event.refresh ?? (currentState as Refresher).community,
        qr: false,
        edit: false,
        common: false,
        profile: false,
      );
    } else if (event is Refresh) {
      yield (currentState as Refresher).copyWith(
        qr: event.qr ?? (currentState as Refresher).qr,
        edit: event.edit ?? (currentState as Refresher).edit,
        common: event.common ?? (currentState as Refresher).common,
        cupertino: event.cupertino ?? (currentState as Refresher).cupertino,
        profile: event.profile ?? (currentState as Refresher).profile,
      );
    }

    return;
  }
}

// -------------- states ------------------
abstract class RefreshState extends Equatable {
  RefreshState([List props = const []]) : super(props);
}

class Refresher extends RefreshState {
  final bool qr;
  final bool edit;
  final bool common;
  final bool profile;
  final bool cupertino;
  final bool community;
  Refresher({
      this.qr,
      this.edit,
      this.common,
      this.profile,
      this.cupertino,
      this.community
  }) : super([
      qr,
      edit,
      common,
      profile,
      cupertino,
      community,
  ]);

  Refresher copyWith({
      bool qr,
      bool edit,
      bool common,
      bool profile,
      bool cupertino,
      bool community,
  }) {
    return Refresher(
      qr: qr ?? this.qr,
      edit: edit ?? this.edit,
      common: common ?? this.common,
      profile: profile ?? this.profile,
      cupertino: cupertino ?? this.cupertino,
      community: community ?? this.community
    );
  }
}

// -------------- events ----------------
abstract class RefreshEvent extends Equatable {}

class Refresh extends RefreshEvent {
  final bool qr;
  final bool edit;
  final bool common;
  final bool profile;
  final bool cupertino;
  Refresh({
      this.qr,
      this.edit,
      this.common,
      this.profile,
      this.cupertino,
  });

  @override
  String toString() => 'Refresh';
}

class PostRefresh extends RefreshEvent {
  final bool refresh;
  PostRefresh({ this.refresh = true });
  @override
  String toString() => 'PostRefresh';
}

class CommunityRefresh extends RefreshEvent {
  final bool refresh;
  CommunityRefresh({ this.refresh = true });
  @override
  String toString() => 'CommunityRefresh';
}
