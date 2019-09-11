import 'package:flutter/material.dart';
import 'package:cdr_today/navigations/args.dart';

class PostItem extends StatelessWidget {
  final ArticleArgs x;
  
  PostItem({ this.x });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        title: Text(
          x.title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400)
        ),
        subtitle: Container(
          child: Text(
            x.content, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)
          ),
          padding: EdgeInsets.only(top: 10.0),
        ),
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
