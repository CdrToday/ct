import 'package:flutter/material.dart';
import 'package:cdr_today/pages/reddit.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/drawer.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/sheets.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Reddit(
        edit: false,
        appBar: SliverAppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()
            ),
          ),
          centerTitle: true,
          title: RedditRefresher(widget: CommunityName()),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey[100],
          snap: true,
          floating: true,
        ),
      ),
      bottomSheet: EditBottomSheet(),
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: SwipeDrawer(),
        elevation: 2.0,
      ),
    );
  }
}
