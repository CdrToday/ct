import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/pages/reddit.dart';
import 'package:cdr_today/pages/bucket.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/drawer.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/sheets.dart';

class InitPage extends StatelessWidget {
  Widget drawer(context) => SizedBox(
    child: Drawer(
      child: SwipeDrawer(),
      elevation: 2.0,
    ),
    width: MediaQuery.of(context).size.width * 8 / 10
  );

  Widget leading(context) => Builder(
    builder: (context) => IconButton(
      icon: Icon(Icons.menu),
      onPressed: () => Scaffold.of(context).openDrawer()
    )
  );
  
  Widget appBar(context) => SliverAppBar(
    leading: leading(context),
    centerTitle: true,
    title: RedditRefresher(widget: CommunityName()),
    automaticallyImplyLeading: false,
    backgroundColor: Colors.grey[100],
    snap: true,
    floating: true,
  );
  
  Widget bottomSheet = EditBottomSheet();  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is Communities) {
          if (state.current == '') {
            return Bucket(
              drawer: drawer(context),
              bottomSheet: bottomSheet,
              leading: leading(context),
            );
          }
        }
        return Scaffold(
          body: Reddit(
            appBar: appBar(context),
          ),
          backgroundColor: Colors.grey[100],
          bottomSheet: bottomSheet,
          drawer: drawer(context),
        );
      }
    );
  }
}
