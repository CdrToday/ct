import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/bar.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/member.dart';
import 'package:cdr_today/x/req.dart' as xReq;

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
          expandedHeight: kToolbarHeight * 2,
          // title: PostRefresh(),
          flexibleSpace: FlexibleSpaceBar(
            title: CommunityName(),
          ),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.settings),
              onPressed: () => Navigator.pushNamed(context, '/community/settings'),
            )
          ]
        ),
      )
    );
  }
}
