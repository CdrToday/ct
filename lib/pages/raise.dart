import 'package:flutter/material.dart';

class Raise extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.person_add),
                title: Text('加入社区'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/community/join'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('创建社区'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(context, '/community/create'),
              ),
            )
          ]
        )
      ),
    );
  }
}
