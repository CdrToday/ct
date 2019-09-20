import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/bar.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/member.dart';

class SwipeMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: null,
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            elevation: 0.4,
            forceElevated: true,
            expandedHeight: kToolbarHeight * 2,
            // title: PostRefresh(),
            flexibleSpace: FlexibleSpaceBar(
              title: CommunityName(),
            ),
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.settings),
                onPressed: () => {},
              )
            ]
          ),
          CommunityMember(),
        ]
      )
    );
  }
}
