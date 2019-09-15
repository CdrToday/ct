import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyDialog extends StatefulWidget {
  final String title;
  final String index;

  ModifyDialog({ this.title, this.index });
  @override
  _ModifyDialogState createState() => _ModifyDialogState();
}

class _ModifyDialogState extends State<ModifyDialog> {
  String _value = '';
  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  Widget build(BuildContext context) {
    final ProfileBloc _bloc = BlocProvider.of<ProfileBloc>(context);

    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              autofocus: true,
              onChanged: changeValue
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('取消'),
          onPressed: () => Navigator.of(context).pop()
        ),
        FlatButton(
          child: Text('修改'),
          onPressed: () {
            _bloc.dispatch(UpdateProfileName(name: _value));
            Navigator.of(context).pop();
            alertLoading(context);
          }
        ),
      ],
    );
  }
}
