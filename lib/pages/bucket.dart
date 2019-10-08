import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/cards.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/refresh.dart';

class Bucket extends StatelessWidget {
  final Widget leading;
  final Widget drawer;
  final List<Widget> actions;
  final Widget bottomSheet;
  Bucket({
      this.drawer,
      this.bottomSheet,
      this.leading,
      this.actions,
  });
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post(
        appBar: SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          snap: true,
          elevation: 0.0,
          forceElevated: true,
          leading: leading ?? Close(),
          title: PostRefresher(),
          actions: actions ?? [],
          centerTitle: true,
        ),
        title: sliverProfile(
          context,
          showEdit: leading != null ? false : true,
        ),
      ),
      drawer: leading != null ? drawer : null,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
    );
  }
}
