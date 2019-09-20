import 'package:flutter/material.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/drawer.dart';
import 'package:cdr_today/widgets/refresh.dart';
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
      bottomSheet: Container(
        child: Row(
          children: [
            SizedBox.shrink(),
            // IconButton(
            //   icon: Icon(Icons.filter_list),
            //   onPressed: () {
            //     Navigator.pushNamed(
            //       context, '/user/edit',
            //       arguments: ArticleArgs(edit: false)
            //     );
            //   },
            //   color: Colors.black,
            // ),
            IconButton(
              icon: Icon(Icons.mode_edit),
              onPressed: () {
                Navigator.pushNamed(
                  context, '/user/edit',
                  arguments: ArticleArgs(edit: false)
                );
              },
              color: Colors.black,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        alignment: AlignmentDirectional.centerEnd,
        constraints: BoxConstraints(maxHeight: 42.0),
        decoration: BoxDecoration(color: Colors.grey[200])
      ),
      drawer: Drawer(
        child: MainDrawer(),
        elevation: 1.0,
      ),
      backgroundColor: Colors.white,
    );
  }
}
