import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/member.dart';
import 'package:cdr_today/widgets/buttons.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CommunityName(limit: true),
        leading: CtClose(),
        border: null,
        trailing: CtNoRipple(
          icon: CupertinoIcons.settings,
          onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
            '/community/settings'
          ),
        ),
      ),
      child: CommunityMember()
    );
  }
}
