import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// --------- bloc --------
class ImageBloc extends Bloc<ImageEvent, ImageState> {
  @override
  Stream<ImageState> transform(
    Stream<ImageEvent> events,
    Stream<ImageState> Function(ImageEvent event) next,
  ) {
    return super.transform(
      (events as Observable<ImageEvent>).debounceTime(
        Duration(milliseconds: 500),
      ), next,
    );
  }
  
  @override
  ImageState get initialState => UploadEmpty();

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async * {
    xReq.Requests r = await xReq.Requests.init();
    
    if (event is UploadImageEvent) {
      yield ImageUploading();
      String img = base64Encode(
        event.image.readAsBytesSync()
      );

      var res = await r.upload(image: img);
      if (res.statusCode == 200) {
        UploadResult _data = UploadResult.fromJson(json.decode(res.body));
        yield ImageUploadSucceed(cover: _data.cover);
      } else {
        yield ImageUploadFailed();
      }
      
      yield UploadEmpty();
    }
  }
}

// -------- state ---------
abstract class ImageState extends Equatable {
  ImageState([List props = const []]) : super(props);
}

class UploadEmpty extends ImageState {
  @override
  String toString() => "UploadEmpty";
}

class ImageUploading extends ImageState {
  @override
  String toString() => "ImageUploading";
}

class ImageUploadSucceed extends ImageState {
  final String cover;
  ImageUploadSucceed({ this.cover });
  
  @override
  String toString() => "ImageUploadSucceed";
}

class ImageUploadFailed extends ImageState {
  @override
  String toString() => "ImageUploadFailed";
}

// ---------- events -----------
abstract class ImageEvent extends Equatable {}

class LoadImageEvent extends ImageEvent {
  String toString() => "LoadImageEvent";
}

class UploadImageEvent extends ImageEvent {
  final File image;
  UploadImageEvent({ this.image });
}

// ---------- API ---------
class UploadResult {
  final String cover;
  UploadResult({ this.cover });
  
  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult( cover: json['cover'] );
  }
}
