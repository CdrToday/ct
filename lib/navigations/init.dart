import 'package:flutter/material.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/drawer.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/sheets.dart';
import 'package:cdr_today/navigations/args.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post(
        edit: false,
        appBar: SliverAppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer()
            ),
          ),
          centerTitle: true,
          title: PostRefresh(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          snap: true,
          floating: true,
        ),
      ),
      bottomSheet: EditBottomSheet(),
      drawer: Drawer(
        child: SwipeDrawer(),
        elevation: 2.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}
