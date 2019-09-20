import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/input.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String _id;
  String _name;
  
  void changeId(String value) {
    setState(() { _id = value; });
  }

  void changeName(String value) {
    setState(() { _name = value; });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建社区'),
        leading: CloseButton(),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () { print('ok'); }
          )
        ]
      ),
      body: Column(
        children: [
          Input(
            helper: '社区 ID: 用于社区搜索，具有唯一性要求。',
            onChanged: changeId,
          ),
          SizedBox(height: 10.0),
          Input(
            helper: '社区名称: 可随意设置。',
            onChanged: changeName,
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
} 
