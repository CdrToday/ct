import './conf.dart';
import './utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

// ------------ bloc -------------
class EditBloc extends Bloc<EditEvent, EditState> {
  @override
  EditState get initialState => Empty();

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    return;
  }
}

// ------------- state ------------
abstract class EditState extends Equatable {
  EditState([List props = const []]) : super(props);
}

class Empty extends EditState {
  @override
  String toString() => 'Empty';
}

class PrePublish extends EditState {
  @override
  String toString() => 'PrePublish';
}

// ------------- events -------------
abstract class EditEvent extends Equatable {}

class CompletedEdit extends EditEvent {
  final String title;
  final String content;
  CompletedEdit({ this.title, this.content });
}

class SaveDraft extends EditEvent {
  final String title;
  final String content;
  SaveDraft({ this.title, this.content });
}
