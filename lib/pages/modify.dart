import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/verify.dart';
import 'package:cdr_today/navigations/args.dart';

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
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.args.title),
          actions: [
            ok(context, _value)
          ]
        ),
        body: Container(
          child: TextField(
            decoration: InputDecoration(hintText: widget.args.title),
            onChanged: changeValue
          ),
          padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0)
        ),
      ),
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode())
    );
  }
}

Widget ok(BuildContext context, String _value) {
  return Builder(
    builder: (context) {
      return IconButton(
        icon: Icon(Icons.check, color: Colors.black),
        onPressed: () {
          if (_value == '') {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text('请输入正确的邮箱'),
              ),
            );
          }
          Navigator.pop(context);
        }
      );
    }
  );
}
