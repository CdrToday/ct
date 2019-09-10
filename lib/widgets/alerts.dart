import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/edit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> deleteArticle(BuildContext context, String id) async {
  final EditBloc _bloc = BlocProvider.of<EditBloc>(context);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('确定'),
            onPressed: () {
              _bloc.dispatch(DeleteEdit(id: id));
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('删除文章?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      );
    },
  );
}

Future<void> alertLoading(BuildContext context, {String text}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: text == null? Text('Calling Elvis'): Text(text),
        content: Padding(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0)
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      );
    },
  );
}
