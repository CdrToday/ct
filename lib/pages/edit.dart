import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/widgets/edit.dart';
import 'package:cdr_today/widgets/image.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/actions.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/navigations/args.dart';

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
    final PostBloc _bloc = BlocProvider.of<PostBloc>(context);
    
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
            _bloc.dispatch(CleanList());
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
      floatingActionButton: ImagePickerWidget(
        image: _image,
        cover: _cover,
        setImage: (image) => setState(() { _image = image; }),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
  
  List<Widget> ctx(BuildContext context) {
    Widget _titleWidget = TitleWidget(
      titleController: _titleController,
      onChanged: (String text) => setState(() { _title = text; }),
    );

    Widget _contentWidget = ContentWidget(
      contentController: _contentController,
      onChanged: (String text) => setState(() { _content = text; }),
    );
    
    Widget _imageWidget = ImageWidget(
      cover: _cover,
      image: _image,
      edit: widget.args.edit,
      setImage: (image) => setState(() { _image = image; }),
      setCover: (cover) => setState(() { _cover = cover; }),
      cleanImage: () => setState(() { _image = null; _cover = ""; }),
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
}
