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
      ),
      child: CommunityMember(
        // appBar: SliverAppBar(
        //   leading: null,
        //   automaticallyImplyLeading: false,
        //   floating: true,
        //   snap: true,
        //   elevation: 0.4,
        //   forceElevated: true,
        //   expandedHeight: kToolbarHeight * 1.6,
        //   flexibleSpace: FlexibleSpaceBar(
        //     title: Container(
        //       child: CommunityName(limit: true),
        //     ),
        //     centerTitle: true,
        //   ),
        //   trailing: CtNoRipple(
        //     icon: CupertinoIcons.settings,
        //     onTap: () {
        //       Navigator.pushNamed(context, '/community/settings');
        //     },
        //   ),
        // ),
      )
    );
  }
}
