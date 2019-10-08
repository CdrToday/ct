import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/member.dart';
import 'package:cdr_today/widgets/buttons.dart';

class SwipeMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommunityMember(
        appBar: SliverAppBar(
          leading: null,
          automaticallyImplyLeading: false,
          floating: true,
          snap: true,
          elevation: 0.4,
          forceElevated: true,
          expandedHeight: kToolbarHeight * 1.6,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              child: CommunityName(limit: true),
            ),
            centerTitle: true,
          ),
          actions: [
            NoRipple(
              icon: Icon(CupertinoIcons.settings),
              onTap: () {
                Navigator.pushNamed(context, '/community/settings');
              },
            )
          ]
        ),
      )
    );
  }
}
