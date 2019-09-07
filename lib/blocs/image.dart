import './conf.dart';
import './utils.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image/image.dart';
import 'package:uuid/uuid.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// --------- bloc --------
class ImageBloc extends Bloc<ImageEvent, ImageState> {
  @override
  ImageState get initialState => UploadEmpty();

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async * {
    var mail = await getString('mail');
    var code = await getString('code');
    var uuid = new Uuid();
    
    if (event is UploadImageEvent) {
      String id = uuid.v4();
      Image temp = decodeImage(event.image.readAsBytesSync());
      Image thum = copyResize(temp, width: 540);
      String img = base64Encode(encodePng(thum));

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

      yield ImageUploading();
      
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
