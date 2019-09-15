import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/actions.dart';
import 'package:cdr_today/widgets/editor.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:zefyr/zefyr.dart';

class Edit extends StatefulWidget {
  final ArticleArgs args;
  Edit({ this.args });
  
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final document = _loadDocument();
    _focusNode = FocusNode();
    _controller = ZefyrController(document);
  }
  
  Widget build(BuildContext context) {
    final PostBloc _bloc = BlocProvider.of<PostBloc>(context);
    
    return Scaffold(
      appBar: AppBar(
        actions: editActions(
          context,
          id: widget.args.id,
          edit: widget.args.edit,
          document: _controller.document
        ),
        title: Text('编辑'),
        leading: widget.args.edit ? BackButton() : CloseButton()
      ),
      body: BlocListener<EditBloc, EditState>(
        listener: (context, state) {
          if (state is Posting) {
            alertLoading(context);
          } else if (state is PublishSucceed) {
            Navigator.pop(context);
            Navigator.maybePop(context);
            // snacker(context, '保存成功。');
            _bloc.dispatch(CleanList());
          } else if (state is UpdateSucceed) {
            Navigator.pop(context);
            snacker(context, '更新成功。', color: Colors.black);
            _bloc.dispatch(CleanList());
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
            _bloc.dispatch(CleanList());
            Navigator.pop(context);
            Navigator.maybePop(context);
          }
        },
        child: Editor(
          focusNode: _focusNode,
          controller: _controller,
          edit: true,
        ),
      ),
    );
  }
  
  NotusDocument _loadDocument() {
    if (widget.args.edit == true) {
      return NotusDocument.fromJson(jsonDecode(widget.args.document));
    }
    
    var data = r'[{"insert":"\n","attributes":{"heading":1}}]';
    return NotusDocument.fromJson(json.decode(data) as List);
  }
}
