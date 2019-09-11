import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/blocs/image.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';

// getImage
Future getImage(
  BuildContext context, {
    void Function(File image) setImage
  }
) async {
  var _image = await ImagePicker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 540.0
  );

  if (_image != null) {
    final _bloc = BlocProvider.of<ImageBloc>(context);
    _bloc.dispatch(UploadImageEvent(image: _image));
    setImage(_image);
  }
}

class ImagePickerWidget extends StatelessWidget {
  final File image;
  final String cover;
  final void Function(File image) setImage;
  ImagePickerWidget({ this.cover, this.image, this.setImage });

  Widget build(BuildContext context) {
    if (image == null && cover == '') {
      return FloatingActionButton(
        onPressed: () => getImage(context, setImage: setImage),
        child: Icon(Icons.add_a_photo),
      );
    }
    return SizedBox.shrink();
  }
}

class ImageWidget extends StatelessWidget {
  final bool edit;
  final File image;
  final String cover;
  final void Function(File image) setImage;
  final void Function(String cover) setCover;
  final void Function() cleanImage;

  ImageWidget({
      this.setImage, this.cleanImage, this.setCover,
      this.edit, this.image, this.cover
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => BlocListener<ImageBloc, ImageState>(
        listener: (context, state) {
          if (state is ImageUploadFailed) {
            snacker(context, '图片上传失败，请重试');
          } else if (state is ImageUploadSucceed) {
            setCover(state.cover);
            Navigator.pop(context);
          } else if (state is ImageUploading) {
            alertLoading(context);
          }
        },
        child: Builder(
          builder: (context) {
            if (image == null) {
              if (edit == true && cover != "") {
                return GestureDetector(
                  child: Center(child: Image.network(conf['image'] + cover)),
                  onLongPress: () => changeImage(context, false),
                  onDoubleTap: () => changeImage(context, true),
                );
              }
              return SizedBox.shrink();
            } 
            return GestureDetector(
              child: Center(child: Image.file(image)),
              onLongPress: () => changeImage(context, false),
              onDoubleTap: () => changeImage(context, true),
            );
          }
        )
      )
    );
  }

  // changeImage
  Future<void> changeImage(BuildContext context, bool del) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
                del == false ? getImage(context, setImage: setImage) : cleanImage();
              },
            ),
          ],
          title: del == true? Text('删除图片?') :Text('修改图片?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
        );
      },
    );
  }
}
