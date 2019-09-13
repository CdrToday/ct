import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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

