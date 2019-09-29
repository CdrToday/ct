import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// avatar actions
class Avatar extends StatelessWidget {
  final ScreenshotController screenshotController;
  Avatar({ this.screenshotController });
  
  void pickImage(BuildContext context) async {
    final UserBloc _ubloc = BlocProvider.of<UserBloc>(context);
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);

    Navigator.pop(context);
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

    _bloc.dispatch(Refresh(profile: true));
    var res = await r.upload(image: image);
    if (res.statusCode != 200) {
      snacker(context, '图片上传失败，请重试');
      return;
    }

    res = await r.updateAvatar(avatar: json.decode(res.body)['image']);
    if (res.statusCode != 200) {
      snacker(context, '头像修改失败，请重试');
      return;
    }

    _ubloc.dispatch(InitUserEvent(avatar: json.decode(res.body)['avatar']));
    _bloc.dispatch(Refresh(profile: false));
  }

  void saveImage(BuildContext context) async {
    File image = await screenshotController.capture(pixelRatio: 1.5);
    bool result = await ImageGallerySaver.saveImage(image.readAsBytesSync());

    result
    ?snacker(context, '保存成功', color: Colors.black)
    :snacker(context, '保存失败');
  }

  CupertinoActionSheet bottomSheet(BuildContext context) => CupertinoActionSheet(
    actions: [
      CupertinoActionSheetAction(
        child: Text('更换'),
        onPressed: () => pickImage(context),
      ),
      CupertinoActionSheetAction(
        child: Text('保存'),
        onPressed: () => saveImage(context),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text('取消'),
      onPressed: () => Navigator.pop(context),
    )
  );


  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: () {
          showCupertinoModalPopup(
            context: context,
            builder: (context) => bottomSheet(context),
          );
        },
        color: Colors.white,
      )
    );
  }
}
