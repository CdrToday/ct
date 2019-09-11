import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/alerts.dart';

// edit Actions
List<Widget> editActions(
  BuildContext context, {
    String title,
    String content,
    String cover,
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

  Builder upload = Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.check),
      onPressed: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        if (title == null || title == '') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('请填写文章标题'),
            ),
          );
        } else if (content == null || content == '') {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('请填写文章内容'),
            ),
          );
        } else {
          if (edit != true) {
            _bloc.dispatch(CompletedEdit(title: title, cover: cover, content: content));
          } else {
            _bloc.dispatch(UpdateEdit(id: id, title: title, cover: cover, content: content));
          }
        }
      }
    )
  );
  
  return [delete, upload];
}

