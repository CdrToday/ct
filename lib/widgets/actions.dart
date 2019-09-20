import 'dart:io';
import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

// edit Actions
List<Widget> editActions(
  BuildContext context, {
    NotusDocument document,
    String id,
    bool edit
  }
) {
  final EditBloc _bloc = BlocProvider.of<EditBloc>(context);
  
  Widget delete = IconButton(
    icon: Icon(Icons.highlight_off),
    onPressed: () => deleteArticle(context, id)
  );

  Widget empty = SizedBox.shrink();

  if (edit != true) {
    delete = empty;
  }

  Builder post = Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.check),
      onPressed: () {
        String json = jsonEncode(document);

        FocusScope.of(context).requestFocus(new FocusNode());
        if (!document.toPlainText().contains(new RegExp(r'\S'))) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('请填写文章内容'),
            ),
          );
          return;
        }
        
        if (edit != true) {
          _bloc.dispatch(CompletedEdit(document: json));
        } else {
          _bloc.dispatch(UpdateEdit(id: id, document: json));
        }
      }
    )
  );
  
  return [delete, post];
}

// article actions
List<Widget> articleActions(BuildContext context, screenshotController) {
  Builder more = Builder(
    builder: (ctx) => IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () async {
        File image = await screenshotController.capture(pixelRatio: 1.5);
        String name = DateTime.now().toString();

        await Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
      }
    )
  );

  return [more];
}

// avatar actions
List<Widget> avatarActions(BuildContext context, screenshotController) {
  final ProfileBloc _profileBloc = BlocProvider.of<ProfileBloc>(context);
  
  void pickImage(BuildContext ctx) async {
    Navigator.pop(ctx);

    final xReq.Requests r = await xReq.Requests.init();
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 540.0,
    );

    if (file == null) return;
    file = await ImageCropper.cropImage(
      sourcePath: file.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
      toolbarTitle: '裁剪',
    );

    if (file == null) return;
    String image = base64Encode(file.readAsBytesSync());
    
    alertLoading(ctx, text: '头像上传中...');
    var res = await r.upload(image: image);
    
    if (res.statusCode != 200) {
      snacker(ctx, '图片上传失败，请重试');
      return;
    }

    UploadResult _data = UploadResult.fromJson(json.decode(res.body));
    _profileBloc.dispatch(UpdateProfileAvatar(avatar: _data.image));
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
        child: Text('更换', style: Theme.of(ctx).textTheme.title),
        onPressed: () => pickImage(ctx),
      ),
      CupertinoActionSheetAction(
        child: Text('保存', style: Theme.of(ctx).textTheme.title),
        onPressed: () => saveImage(ctx),
      ),
    ],
    cancelButton: CupertinoActionSheetAction(
      child: Text('取消', style: Theme.of(ctx).textTheme.title),
      isDefaultAction: true,
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

Widget blog() {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        return IconButton(
          icon: Icon(Icons.public),
          onPressed: () async {
            await launch('https://cdr.today/${state.name}');
          },
          color: Colors.black,
        );
      }
      return SizedBox.shrink();
    }
  );
}

// ---------- API ---------
class UploadResult {
  final String image;
  UploadResult({ this.image });
  
  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult( image: json['image'] );
  }
}
