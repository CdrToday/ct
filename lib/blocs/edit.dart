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
    if (event is CompletedEdit) {
      var mail = await getString('mail');
      var res = await http.post(
        "${conf['url']}/${mail}/publish",
        body: {
          'title': event.title,
          'content': event.content
        }
      );
      if (res.statusCode == 200) {
        yield PublishSucceed();
      } else {
        yield PublishFailed();
      }
    }
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

class PublishSucceed extends EditState {
  @override
  String toString() => 'PublishSucceed';
}

class PublishFailed extends EditState {
  @override
  String toString() => 'PublishFailed';
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
