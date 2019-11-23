import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/report.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/_style/color.dart';

class ArticleAction extends StatelessWidget {
  final BuildContext sContext;
  final ArticleArgs args;
  ArticleAction({ this.sContext, this.args });

  bottomSheet(BuildContext context) => Container(
    child: SafeArea(
      child: Wrap(
        children: [
          Container(
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.face, color: CtColors.primary, size: 22.0
                  ),
                  SizedBox(width: 10.0),
                  Text('查看作者', style: TextStyle(color: CtColors.primary)),
                ]
              ),
              onTap: () => goPost(context)
            ),
          ),
          CtDivider(indent: 15.0),
          Container(child: ReportTile(sContext: context, id: args.id))
        ],
      )
    ),
    color: CtColors.gray6,
  );

  goPost(BuildContext context) {
    Navigator.of(
      context, rootNavigator: true
    ).popAndPushNamed(
      '/post', arguments: PostArgs(
        ident: args.mail,
        community: args.community
      )
    );
  }
  
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CtNoRipple(
        icon: Icons.more_horiz,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => bottomSheet(context),
          );
        },
      )
    );
  }
}
