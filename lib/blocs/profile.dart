import './conf.dart';
import './utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

// Profile
// ----------- bloc ------------
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  @override
  ProfileState get initialState => EmptyProfileState();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is UpdateProfileName) {
      String code = await getString('code');
      String mail = await getString('mail');

      Map data = {
        'name': event.name
      };
      
      var res = await http.post(
        "${conf['url']}/$mail/update/name",
        headers: {
          'code': code
        },
        body: json.encode(data),
      );

      if (res.statusCode == 200) {
        ProfileUpdateResult _data = ProfileUpdateResult.fromJson(json.decode(res.body));
        yield ProfileUpdatingSucceed(
          mail: _data.data['mail'],
          name: _data.data['name']
        );
        yield EmptyProfileState();
      } else {
        yield ProfileUpdatingFailed();
        yield EmptyProfileState();
      }
    }
  }
}

// --------- events ---------
abstract class ProfileEvent extends Equatable{}

class UpdateProfileName extends ProfileEvent {
  final String name;
  UpdateProfileName({ this.name });

  @override
  String toString() => 'UpdateProfileName';
}

// --------- states --------
abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super(props);
}

class EmptyProfileState extends ProfileState {
  @override
  String toString() => 'EmptyProfileState';
}

class ProfileUpdatingFailed extends ProfileState {
  @override
  String toString() => 'ProfileUpdatingFailed';
}

class ProfileUpdatingSucceed extends ProfileState {
  final String mail;
  final String name;

  ProfileUpdatingSucceed({this.mail, this.name});
  @override
  String toString() => 'ProfileUpdatingSucceed';
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
