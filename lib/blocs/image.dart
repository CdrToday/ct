import './conf.dart';
import './utils.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';

// --------- bloc --------
class ImageBloc extends Bloc<ImageEvent, ImageState> {
  @override
  ImageState get initialState => UploadEmpty();

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async * {
    var mail = await getString('mail');
    var code = await getString('code');

    if (event is UploadImageEvent) {
      yield ImageUploading();
      String img = base64Encode(
        event.image.readAsBytesSync()
      );

      Map data = {
        'image': img
      };
      
      var res = await http.post(
        "${conf['url']}/$mail/upload",
        headers: {
          'code': code,
        },
        body: json.encode(data)
      );
      
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
