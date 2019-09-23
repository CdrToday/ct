import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// avatar actions
List<Widget> avatarActions(BuildContext context, screenshotController) {
  final ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
  
  void pickImage(BuildContext ctx) async {
    Navigator.pop(ctx);

    final xReq.Requests r = await xReq.Requests.init();
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024.0,
    );

    if (file == null) return;
    file = await ImageCropper.cropImage(
      sourcePath: file.path,
      ratioX: 1.0,
      ratioY: 1.0,
      toolbarTitle: '',
    );

    if (file == null) return;
    String image = base64Encode(file.readAsBytesSync());
    
    alertLoading(ctx, text: '头像上传中...');
    var res = await r.upload(image: image);
    
    if (res.statusCode != 200) {
      Navigator.pop(context);
      snacker(ctx, '图片上传失败，请重试');
      return;
    }

    _profileBloc.dispatch(
      UpdateProfileAvatar(avatar: json.decode(res.body)['image'])
    );
    Navigator.pop(ctx);
  }

  void saveImage(BuildContext ctx) async {
    File image = await screenshotController.capture(pixelRatio: 1.5);
    bool result = await ImageGallerySaver.saveImage(image.readAsBytesSync());

    Navigator.pop(ctx);
    
    result
    ?snacker(ctx, '保存成功', color: Colors.black)
    :snacker(ctx, '保存失败');
  }

  CupertinoActionSheet bottomSheet(BuildContext ctx) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        child: Text('更换'),
        onPressed: () => pickImage(ctx),
      ),
      CupertinoActionSheetAction(
        child: Text('保存'),
        onPressed: () => saveImage(ctx),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text('取消'),
      onPressed: () => Navigator.pop(ctx),
    )
  );
  
  Builder changeImage = Builder(
    builder: (_context) => IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => bottomSheet(_context),
        );
      },
      color: Colors.white,
    )
  );

  return [changeImage];
}
