import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/refresh.dart';

class Bucket extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post(
        edit: true,
        appBar: SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          snap: true,
          elevation: 0.4,
          forceElevated: true,
          expandedHeight: kToolbarHeight * 3,
          leading: CloseButton(),
          title: PostRefresh(),
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              child: AvatarHero(
                self: true, width: 22.0,
                onTap: () => Navigator.pushNamed(context, '/mine/profile'),
              ),
              padding: EdgeInsets.only(bottom: kToolbarHeight / 3)
            ),
          )
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
