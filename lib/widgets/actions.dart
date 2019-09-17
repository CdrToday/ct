import 'dart:io';
import 'dart:convert';
import 'package:zefyr/zefyr.dart';
import 'package:flutter/material.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

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
    builder: (_context) => IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () async {
        File image = await screenshotController.capture(pixelRatio: 1.5);
        String name = DateTime.now().toString();
        Share.file(name, "$name.png", image.readAsBytesSync(), 'image/png');
      }
    )
  );

  return [more];
}

// avatar actions
List<Widget> avatarActions(BuildContext context, screenshotController) {
  void pickImage(BuildContext ctx) async {
    final xReq.Requests r = await xReq.Requests.init();
    
    final file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 540.0,
    );

    if (file == null) return null;
    String image = base64Encode(file.readAsBytesSync());
    alertLoading(context, text: '图片上传中...');

    var res = await r.upload(image: image);
    if (res.statusCode != 200) snacker(context, '图片上传失败，请重试');
    
    UploadResult _data = UploadResult.fromJson(json.decode(res.body));
    //
  }

  void saveImage(BuildContext ctx) async {
    File image = await screenshotController.capture(pixelRatio: 1.5);
    bool result = await ImageGallerySaver.saveImage(image.readAsBytesSync());

    Navigator.pop(ctx);
    
    result
    ?snacker(ctx, '保存成功', color: Colors.black)
    :snacker(ctx, '保存失败');
  }

  BottomSheet bottomSheet(BuildContext ctx) => BottomSheet(
    builder: (context) {
      return Container(
        child: Column(
          children: [
            ListTile(
              title: Text('更换头像', textAlign: TextAlign.center),
              onTap: () => pickImage(ctx),
            ),
            Divider(indent: 15.0, endIndent: 15.0),
            ListTile(
              title: Text('保存头像', textAlign: TextAlign.center),
              onTap: () => saveImage(ctx),
            ),
          ],
        ),
        height: 180.0,
      );
    },
    onClosing: () => null,
  );
  
  Builder changeImage = Builder(
    builder: (_context) => IconButton(
      icon: Icon(Icons.more_horiz),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => bottomSheet(_context),
        );
      }
    )
  );

  return [changeImage];
}

// ---------- API ---------
class UploadResult {
  final String image;
  UploadResult({ this.image });
  
  factory UploadResult.fromJson(Map<String, dynamic> json) {
    return UploadResult( image: json['image'] );
  }
}
