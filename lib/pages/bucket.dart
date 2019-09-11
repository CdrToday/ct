import 'package:flutter/material.dart';
import 'package:cdr_today/pages/posts.dart';

class Bucket extends StatelessWidget {
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文章管理'),
        leading: CloseButton()
      ),
      body: Posts(edit: true)
    );
  }  
}
