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
    var mail = await getString('mail');
    var code = await getString('code');
    
    if (event is CompletedEdit) {
      yield Posting();
      Map data = {
        'title': event.title,
        'cover': event.cover,
        'content': event.content,
      };
      
      var res = await http.post(
        "${conf['url']}/$mail/publish",
        headers: {
          'code': code,
        },
        body: json.encode(data),
      );
      if (res.statusCode == 200) {
        yield PublishSucceed();
        yield Empty();
      } else {
        yield PublishFailed();
        yield Empty();
      }
    } else if (event is UpdateEdit) {
      yield Posting();
      var mail = await getString('mail');
      Map data = {
        'id': event.id,
        'title': event.title,
        'cover': event.cover,
        'content': event.content
      };

      var res = await http.post(
        "${conf['url']}/$mail/article/update",
        headers: {
          'code': code
        },
        body: json.encode(data),
      );
      if (res.statusCode == 200) {
        yield UpdateSucceed();
        yield Empty();
      } else {
        yield UpdateFailed();
      }
      
    } else if (event is DeleteEdit) {
      yield Posting();
      var mail = await getString('mail');
      Map data = {
        'id': event.id,
      };
      
      var res = await http.post(
        "${conf['url']}/$mail/article/delete",
        headers: {
          'code': code
        },
        body: json.encode(data),
      );
      if (res.statusCode == 200) {
        yield DeleteSucceed();
        yield Empty();
      } else {
        yield DeleteFailed();
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

class Posting extends EditState {
  @override
  String toString() => 'Posting';
}

class DeleteSucceed extends EditState {
  @override
  String toString() => 'DeleteSucceed';
}

class DeleteFailed extends EditState {
  @override
  String toString() => 'DeleteFailed';
}

class UpdateSucceed extends EditState {
  @override
  String toString() => 'UpdateSucceed';
}

class UpdateFailed extends EditState {
  @override
  String toString() => 'UpdateFailed';
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

class UpdateEdit extends EditEvent {
  final String id;
  final String title;
  final String cover;
  final String content;
  UpdateEdit({ this.id, this.title, this.cover, this.content });
}

class CompletedEdit extends EditEvent {
  final String title;
  final String cover;
  final String content;
  CompletedEdit({ this.title, this.cover, this.content });
}

class DeleteEdit extends EditEvent {
  final String id;
  DeleteEdit({ this.id });
}
