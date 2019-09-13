import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// ------------ bloc -------------
class EditBloc extends Bloc<EditEvent, EditState> {
  @override
  Stream<EditState> transform(
    Stream<EditEvent> events,
    Stream<EditState> Function(EditEvent event) next,
  ) {
    return super.transform(
      (events as Observable<EditEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  EditState get initialState => EmptyEditState();

  @override
  Stream<EditState> mapEventToState(EditEvent event) async* {
    xReq.Requests r = await xReq.Requests.init();
    
    if (event is CompletedEdit) {
      yield Posting();
      var res = await r.newPost(document: event.document);
      if (res.statusCode == 200) {
        yield PublishSucceed();
      } else {
        yield PublishFailed();
      }
      
      yield EmptyEditState();
    } else if (event is UpdateEdit) {
      yield Posting();
      var res = await r.updatePost(id: event.id, document: event.document);
      
      if (res.statusCode == 200) {
        yield UpdateSucceed();
      } else {
        yield UpdateFailed();
      }

      yield EmptyEditState();
    } else if (event is DeleteEdit) {
      yield Posting();
      var res = await r.deletePost(id: event.id);
      
      if (res.statusCode == 200) {
        yield DeleteSucceed();
      } else {
        yield DeleteFailed();
      }

      yield EmptyEditState();
    }
    return;
  }
}

// ------------- state ------------
abstract class EditState extends Equatable {
  EditState([List props = const []]) : super(props);
}

class EmptyEditState extends EditState {
  @override
  String toString() => 'EmptyEditState';
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
  final String document;
  UpdateEdit({ this.id, this.document });
}

class CompletedEdit extends EditEvent {
  final String document;
  CompletedEdit({ this.document });
}

class DeleteEdit extends EditEvent {
  final String id;
  DeleteEdit({ this.id });
}
