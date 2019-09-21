import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/sheets.dart';
import 'package:cdr_today/navigations/args.dart';

class Bucket extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post(
        edit: true,
        appBar: SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          snap: true,
          elevation: 0.0,
          forceElevated: true,
          leading: CloseButton(),
          title: PostRefresh(),
        ),
        title: title(context)
      ),
      backgroundColor: Colors.white,
    );
  }
}

Widget title(BuildContext context) => SliverList(
  delegate: SliverChildBuilderDelegate(
    (BuildContext context, int index) {
      return Container(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Container(
              child: Row(
                children:[
                  Spacer(),
                  AvatarHero(
                    width: 38.0,
                    self: true,
                    onTap: () => Navigator.pushNamed(context, '/mine/profile'),
                  ),
                  Spacer(),
                ]
              ),
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0)
            ),
            Container(
              child: IconButton(
                icon: Icon(
                  Icons.mode_edit,
                  size: 20.0,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context, '/user/edit',
                    arguments: ArticleArgs(edit: false)
                  );
                },
                color: Colors.black,
              ),
              alignment: Alignment.bottomRight
            ),
            Divider(),
          ]
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.0)
      );
    }, childCount: 1
  )
);
