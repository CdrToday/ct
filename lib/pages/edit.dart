import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/conf.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/image.dart';
import 'package:cdr_today/blocs/article_list.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/actions.dart';
import 'package:cdr_today/widgets/snackers.dart';


class Edit extends StatefulWidget {
  final ArticleArgs args;
  Edit({ this.args });
  
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController _titleController;
  TextEditingController _contentController;

  File _image;
  String _title = '';
  String _content = '';
  String _cover = '';

  @override
  void initState() {
    super.initState();
    if (widget.args.edit == true) {
      _title = widget.args.title;
      _content = widget.args.content;
      _cover = widget.args.cover;
      _titleController = new TextEditingController(text: widget.args.title);
      _contentController = new TextEditingController(text: widget.args.content);
    } else {
      _titleController = new TextEditingController(text: '');
      _contentController = new TextEditingController(text: '');
    }
  }
  
  Widget build(BuildContext context) {
    final ArticleListBloc _alBloc = BlocProvider.of<ArticleListBloc>(context);
    
    return Scaffold(
      appBar: AppBar(
        actions: editActions(
          context,
          cover: _cover,
          title: _title,
          content: _content,
          id: widget.args.id,
          edit: widget.args.edit,
        ),
        title: Text('编辑'),
        leading: widget.args.edit? BackButton():CloseButton()
      ),
      body: BlocListener<EditBloc, EditState>(
        listener: (context, state) {
          if (state is Posting) {
            // must have
            alertLoading(context);
          } else if (state is PublishFailed) {
            Navigator.pop(context);
            snacker(context, '发布失败，请重试');
          } else if (state is DeleteFailed) {
            Navigator.pop(context);
            snacker(context, '删除失败，请重试');
          } else if (state is UpdateFailed) {
            Navigator.pop(context);
            snacker(context, '更新失败，请重试');
          } else if (state is EmptyEditState) {
            return;
          } else {
            // succeed
            _alBloc.dispatch(CleanList());
            Navigator.pop(context);
            Navigator.maybePop(context);
          }
        },
        child: BlocBuilder<EditBloc, EditState>(
          builder: (context, state) {
            return GestureDetector(
              child: Column(
                children: ctx(context),
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
            );
          }
        ),
      ),
      floatingActionButton: imagePicker(context),
      resizeToAvoidBottomPadding: true,
    );
  }
  
  // widgets
  Widget imagePicker(BuildContext context) {
    if (_image == null && _cover == '') {
      return FloatingActionButton(
        onPressed: () => getImage(context),
        child: Icon(Icons.add_a_photo),
      );
    }
    return SizedBox.shrink();
  }

  List<Widget> ctx(BuildContext context) {
    Widget _titleWidget = TextField(
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700
      ),
      decoration: InputDecoration(
        hintText: '标题',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      scrollPadding: EdgeInsets.all(20.0),
      controller: _titleController,
      onChanged: (String text) {
        setState(() { _title = text; });
      }
    );

    Widget _contentWidget = TextField(
      decoration: InputDecoration(
        hintText: '内容',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _contentController,
      onChanged: (String text) => setState(() { _content = text; }),
    );
    
    Widget _imageWidget = Builder(
      builder: (context) => BlocListener<ImageBloc, ImageState>(
        listener: (context, state) {
          if (state is ImageUploadFailed) {
            snacker(context, '图片上传失败，请重试');
          } else if (state is ImageUploadSucceed) {
            setState(() {
                _cover = state.cover;
            });
            Navigator.pop(context);
          } else if (state is ImageUploading) {
            alertLoading(context);
          }
        },
        child: Builder(
          builder: (context) {
            if (_image == null) {
              if (widget.args.edit == true && _cover != "") {
                return GestureDetector(
                  child: Center(child: Image.network(conf['image'] + _cover)),
                  onLongPress: () => changeImage(context, false),
                  onDoubleTap: () => changeImage(context, true),
                );
              }
              return SizedBox.shrink();
            } 
            return GestureDetector(
              child: Center(child: Image.file(_image)),
              onLongPress: () => changeImage(context, false),
              onDoubleTap: () => changeImage(context, true),
            );
          }
        )
      )
    );

    Widget _ctx = Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: _titleWidget,
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 5.0),
            ),
            _imageWidget,
            Container(
              child: _contentWidget,
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
            ),
          ],
        ),
      ),
    );
    
    return <Widget>[_ctx];
  }

  // funcs
  Future getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 540.0
    );

    if (image != null) {
      final _bloc = BlocProvider.of<ImageBloc>(context);
      
      setState(() {
          _bloc.dispatch(UploadImageEvent(image: image));
          _image = image;
      });
    }
  }

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
                if (del == false) {
                  getImage(context);
                } else {
                  setState(() {
                      _image = null;
                      _cover = "";
                  });
                }
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
