import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/community.dart';
import 'package:cdr_today/widgets/_actions/pop.dart';

class CommunityListPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: CommunityRefresher(widget: Text('社区')),
        trailing: CommunityPopMenu(
          child: CtNoRipple(icon: Icons.add_circle_outline),
        ),
        border: null,
      ),
      child: Column(
        children: <Widget>[
          CommunityList(),
        ],
      ),
    );
  }
}
