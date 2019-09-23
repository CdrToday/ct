import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/input.dart';

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  // String _id;
  // void changeId(String value) {
  //   setState(() { _id = value; });
  // }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('加入社区'),
        leading: CloseButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () { print('ok'); }
          )
        ]
      ),
      body: Input(
        helper: '请输入社区 ID',
        // onChanged: changeId,
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
} 
