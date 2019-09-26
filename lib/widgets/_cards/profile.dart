import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/avatar.dart';


SliverList sliverProfile(BuildContext context, {bool showEdit = true}) {
  return SliverList(
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
                padding: EdgeInsets.only(
                  bottom: showEdit ? 10.0 : 50.0,
                  top: 10.0
                )
              ),
              Container(
                child: showEdit ? IconButton(
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
                ) : SizedBox.shrink(),
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
}
