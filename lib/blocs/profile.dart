import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  Stream<ProfileState> transform(
    Stream<ProfileEvent> events,
    Stream<ProfileState> Function(ProfileEvent event) next,
  ) {
    return super.transform(
      (events as Observable<ProfileEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  ProfileState get initialState => EmptyProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();
    if (event is UpdateProfileName) {
      yield ProfileUpdating();
      bool valid = RegExp(r"^[a-z]+$").hasMatch(event.name);
      if (valid == false) {
        yield ProfileNameCheckedFailed();
        yield EmptyProfileState();
        return;
      }
      
      var res = await r.updateName(name: event.name);

      if (res.statusCode == 200) {
        ProfileUpdateResult _data = ProfileUpdateResult.fromJson(json.decode(res.body));
        yield ProfileUpdatedSucceed(name: _data.data['name']);
      } else {
        yield ProfileUpdatedFailed();
      }
      yield EmptyProfileState();
    } else if (event is UpdateProfileAvatar) {
      var res = await r.updateAvatar(avatar: event.avatar);
      
      if (res.statusCode == 200) {
        ProfileUpdateResult _data = ProfileUpdateResult.fromJson(json.decode(res.body));
        yield ProfileAvatarUpdatedSucceed(avatar: _data.data['avatar']);
      } else {
        yield ProfileAvatarUpdatedFailed();
      }
      yield EmptyProfileState();
    }
  }
}

// --------- states --------
abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class EmptyProfileState extends ProfileState {
  @override
  String toString() => 'EmptyProfileState';
}

class ProfileUpdating extends ProfileState {
  @override
  String toString() => 'ProfileUpdating';
}

class ProfileNameCheckedFailed extends ProfileState {
  @override
  String toString() => 'ProfileNameCheckedFailed';
}

class ProfileUpdatedFailed extends ProfileState {
  @override
  String toString() => 'ProfileUpdatingFailed';
}

class ProfileUpdatedSucceed extends ProfileState {
  final String name;

  ProfileUpdatedSucceed({this.name});
  @override
  String toString() => 'ProfileUpdatedSucceed';
}

class ProfileAvatarUpdatedSucceed extends ProfileState {
  final String avatar;

  ProfileAvatarUpdatedSucceed({this.avatar});
  @override
  String toString() => 'ProfileAvatarUpdatedSucceed';
}

class ProfileAvatarUpdatedFailed extends ProfileState {
  @override
  String toString() => 'ProfileAvatarUpdatedFailed';
}

// --------- events ---------
abstract class ProfileEvent extends Equatable{}

class UpdateProfileName extends ProfileEvent {
  final String name;
  UpdateProfileName({ this.name });

  @override
  String toString() => 'UpdateProfileName';
}

class UpdateProfileAvatar extends ProfileEvent {
  final String avatar;
  UpdateProfileAvatar({ this.avatar });

  @override
  String toString() => 'UpdateProfileAvatar';
}

// -------------- apis ---------------------
class ProfileUpdateResult {
  final String msg;
  final Map<String, dynamic> data;
  ProfileUpdateResult({ this.msg, this.data });

  factory ProfileUpdateResult.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResult( msg: json['msg'], data: json['data']);
  }
}
