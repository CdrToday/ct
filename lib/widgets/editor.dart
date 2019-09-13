import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/x/req.dart' as xReq;


class Editor extends StatelessWidget {
  final bool edit;
  final FocusNode focusNode;
  final ZefyrController controller;

  Editor({ this.controller, this.focusNode, this.edit });
  
  @override
  Widget build(BuildContext context) {
    return  ZefyrScaffold(
      child: ZefyrEditor(
        padding: EdgeInsets.all(20.0),
        controller: controller,
        focusNode: focusNode,
        mode: ZefyrMode(
          canEdit: edit,
          canSelect: true,
          canFormat: true,
        ),
        imageDelegate: ImageDelegate(context: context),
      ),
    );
  }
}

class ImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  final BuildContext context;
  ImageDelegate({this.context});
  
  @override
  Future<String> pickImage(ImageSource source) async {
    final xReq.Requests r = await xReq.Requests.init();
    
    final file = await ImagePicker.pickImage(
      source: source,
      maxWidth: 540.0,
    );

    // return if not choose
    if (file == null) return null;

    // upload
    String image = base64Encode(file.readAsBytesSync());
    alertLoading(context, text: '图片上传中...');

    var res = await r.upload(image: image);
    Navigator.pop(context);
    
    if (res.statusCode != 200) snacker(context, '图片上传失败，请重试');

    // return data
    UploadResult _data = UploadResult.fromJson(json.decode(res.body));
    return _data.image;
  }

  Widget buildImage(BuildContext context, String key) {
    return OverflowBox(
      minWidth: 0.0, 
      minHeight: 0.0, 
      maxWidth: double.infinity, 
      child: Image.network(
        Uri.parse(conf['image'] + key).toString(),
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width - 32.0,
      )
    );
  }
}

// ---------- API ---------
class UploadResult {
  final String image;
  UploadResult({ this.image });
  
  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult( image: json['image'] );
  }
}
