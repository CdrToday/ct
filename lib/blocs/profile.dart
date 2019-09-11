import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  ProfileState get initialState => EmptyProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();
    if (event is UpdateProfileName) {
      var res = await r.updateName(name: event.name);

      if (res.statusCode == 200) {
        ProfileUpdateResult _data = ProfileUpdateResult.fromJson(json.decode(res.body));
        yield ProfileUpdatedSucceed(
          mail: _data.data['mail'],
          name: _data.data['name']
        );
      } else {
        yield ProfileUpdatedFailed();
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

class ProfileUpdatedFailed extends ProfileState {
  @override
  String toString() => 'ProfileUpdatingFailed';
}

class ProfileUpdatedSucceed extends ProfileState {
  final String mail;
  final String name;

  ProfileUpdatedSucceed({this.mail, this.name});
  @override
  String toString() => 'ProfileUpdatedSucceed';
}

// --------- events ---------
abstract class ProfileEvent extends Equatable{}

class UpdateProfileName extends ProfileEvent {
  final String name;
  UpdateProfileName({ this.name });

  @override
  String toString() => 'UpdateProfileName';
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
