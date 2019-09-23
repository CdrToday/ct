import 'dart:io';
import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        controller: controller,
        focusNode: focusNode,
        mode: edit? ZefyrMode.edit : ZefyrMode.view,
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
    
    File file = await ImagePicker.pickImage(
      source: source,
      maxWidth: 1024.0,
    );

    if (file == null) return null;
    file = await ImageCropper.cropImage(
      sourcePath: file.path,
      toolbarTitle: '',
    );

    if (file == null) return null;
    String image = base64Encode(file.readAsBytesSync());

    alertLoading(context, text: '图片上传中...');
    var res = await r.upload(image: image);
    Navigator.pop(context);
    
    if (res.statusCode != 200) {
      snacker(context, '图片上传失败，请重试');
      return '';
    }

    // return data
    return json.decode(res.body)['image'];
  }
  
  Widget buildImage(BuildContext context, String key) {
    return Image.network(
      conf['image'] + key,
      fit: BoxFit.fitWidth,
      width: MediaQuery.of(context).size.width - 32.0
    );
  }
}
