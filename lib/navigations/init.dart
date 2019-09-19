import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/pages/mine.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/widgets/drawer.dart';
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
            )
          ),
          centerTitle: true,
          title: BlocBuilder<RefreshBloc, RefreshState>(
            builder: (context, state) {
              if (state is PostRefreshStart) {
                return Container(
                  child: SizedBox(
                    height: 12.0,
                    width: 12.0,
                    child: CircularProgressIndicator(strokeWidth: 1.0)
                  ),
                );
              }
              return SizedBox.shrink();                      
            }
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
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
      drawer: Drawer(child: MainDrawer()),
      backgroundColor: Colors.white,
    );
  }
}
