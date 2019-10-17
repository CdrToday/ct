import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/buttons.dart';

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
                child: showEdit ? CtNoRipple(
                  icon: Icons.mode_edit,
                  onTap: () {
                    Navigator.pushNamed(
                      context, '/user/edit',
                      arguments: ArticleArgs(edit: false)
                    );
                  },
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

class ProfileCard extends StatelessWidget {
  @override
  build(BuildContext context) {
    return Container(
      child: Row(
        children:[
          Spacer(),
          AvatarHero(
            width: 38.0,
            self: true,
            onTap: () => Navigator.pushNamed(
              context, '/mine/profile', arguments: ProfileArgs(raw: true)
            ),
          ),
          Spacer(),
        ]
      ),
      height: MediaQuery.of(context).size.height  / 3
    );
  }
}
