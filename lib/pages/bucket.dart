import 'package:flutter/material.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Bucket extends StatelessWidget {
    Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            snap: true,
            floating: true,
            elevation: 0.0,
            forceElevated: false,
            expandedHeight: kToolbarHeight * 3 / 2,
            leading: CloseButton(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  child: Text(
                    '文章管理',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left
                  ),
                  padding: EdgeInsets.only(
                    left: kToolbarHeight / 2,
                    bottom: kToolbarHeight / 3
                  ),
                  alignment: Alignment.bottomLeft,
                  color: Colors.white,
                );
              }, childCount: 1
            )
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

Widget blog() {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        return IconButton(
          icon: Icon(Icons.explore),
          onPressed: () async {
            await launch('https://cdr.today/${state.name}');
          },
          color: Colors.black,
        );
      }
      return SizedBox.shrink();
    }
  );
}
