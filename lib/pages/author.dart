import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:url_launcher/url_launcher.dart';

class Author extends StatelessWidget {
  final AuthorArgs args;
  Author({ this.args });

  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthorPostContainer(
        appBar: appBar(context, args),
        title: title(context, args),
        mail: args.mail,
      ),
      backgroundColor: Colors.white,
    );
  }
}

Widget appBar(BuildContext context, AuthorArgs args) => SliverAppBar(
  backgroundColor: Colors.white,
  floating: true,
  snap: true,
  elevation: 0.0,
  forceElevated: true,
  leading: CloseButton(),
  title: AuthorRefresher(widget: Text(args.name)),
  centerTitle: true,
  actions: [
    IconButton(
      icon: Icon(Icons.mail, size: 20.0),
      onPressed: () async {
        var url = 'mailto:${args.mail}?subject=hi! ${args.name}';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    )
  ],
);

Widget title(BuildContext context, AuthorArgs args) => SliverList(
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
                    width: 34.0,
                    url: args.avatar,
                    tag: args.avatar,
                    baks: [args.name],
                    onTap: () => Navigator.pushNamed(
                      context, '/avatar',
                      arguments: CustomAvatarArgs(
                        tag: args.avatar,
                        url: args.avatar,
                        baks: [args.name, args.mail],
                        rect: true,
                      )
                    ),
                  ),
                  Spacer(),
                ]
              ),
              padding: EdgeInsets.only(bottom: 30.0, top: 20.0)
            ),
            Divider(),
          ]
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0)
      );
    }, childCount: 1
  )
);
