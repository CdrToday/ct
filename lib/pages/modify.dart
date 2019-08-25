import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/verify.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Modify extends StatefulWidget {
  final ModifyArgs args;
  Modify({ this.args });
  
  @override
  _ModifyState createState() => _ModifyState();
}

class _ModifyState extends State<Modify> {
  String _value = '';
  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title),
        actions: [
          Builder(
            builder: (context) => _ok(context, widget.args.index, _value)
          )
        ]
      ),
      body: Container(
        child: TextField(
          decoration: InputDecoration(hintText: widget.args.title),
          onChanged: changeValue
        ),
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0)
      )
    );
  }
}

Widget _ok(BuildContext context, String index, String _value) {
  final VerifyBloc _bloc = BlocProvider.of<VerifyBloc>(context);
  
  if (index == 'mail') {
    return BlocListener<VerifyBloc, VerifyState>(
      child: IconButton(
        icon: Icon(Icons.check, color: Colors.white),
        onPressed: () {
          bool emailValid = RegExp(
            r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
          ).hasMatch(_value);
          
          if (!emailValid) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text('请输入正确的邮箱'),
              ),
            );
          } else {
            _bloc.dispatch(SendCodeEvent(mail: _value));
          }
        }
      ),
      listener: (context, state) {}
    );
  }
}
