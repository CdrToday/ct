import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cdr_today/x/time.dart';
import 'package:cdr_today/navigations/args.dart';

class PostItem extends StatelessWidget {
  final ArticleArgs x;
  
  PostItem({ this.x });
  @override
  Widget build(BuildContext context) {
    List<dynamic> json = jsonDecode(x.document);
    String title;
    for (var i in json) {
      if (i['insert'].contains(new RegExp(r'\S'))) {
        title = i['insert'];
        break;
      }
    }
    
    return GestureDetector(
      child: ListTile(
        title: Container(
          child: Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400)),
          padding: EdgeInsets.only(top: kToolbarHeight / 8),
        ),
        subtitle: Container(
          child: Text(display(x.timestamp), style: TextStyle(fontSize: 11.0)),
          padding: EdgeInsets.only(top: 50.0),
          alignment:  AlignmentDirectional.bottomEnd
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.0, horizontal: 20.0
        )
      ),
      onTap: () {
        if (x.edit == true) {
          Navigator.pushNamed(context, '/user/edit', arguments: x);
        } else {
          Navigator.pushNamed(context, '/article', arguments: x);
        }
      }
    );
  }
}
