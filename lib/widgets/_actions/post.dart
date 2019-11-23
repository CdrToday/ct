import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/report.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/x/_style/color.dart';

class PostAction extends StatelessWidget {
  final BuildContext sContext;
  final String id;
  PostAction({ this.sContext, this.id });

  bottomSheet(BuildContext context) => Container(
    child: SafeArea(
      child: Wrap(
        children: [
          CtDivider(indent: 15.0),
          Container(child: ReportTile(sContext: context, id: id))
        ],
      )
    ),
    color: CtColors.gray6,
  );
  
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
