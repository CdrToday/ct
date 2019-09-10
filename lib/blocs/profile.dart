import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:cdr_today/blocs/conf.dart';
import 'package:cdr_today/blocs/utils.dart';

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
