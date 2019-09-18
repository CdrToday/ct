import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Bucket extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post(
        edit: true,
        title: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return index == 0
              ? Row(
                children: [
                  Container(
                    child: Text(
                      '文章管理',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left
                    ),
                    padding: EdgeInsets.only(
                      left: kToolbarHeight / 3,
                      bottom: kToolbarHeight / 3
                    ),
                    alignment: Alignment.bottomLeft,
                    color: Colors.white,
                  ),
                  BlocBuilder<RefreshBloc, RefreshState>(
                    builder: (context, state) {
                      if (state is PostRefreshStart) {
                        return Container(
                          child: SizedBox(
                            height: 16.0,
                            width: 16.0,
                            child: CircularProgressIndicator(strokeWidth: 2.0)
                          ),
                          margin: EdgeInsets.only(left: 10.0, bottom: kToolbarHeight / 3)
                        );
                      }
                      return SizedBox.shrink();                      
                    }
                  ),
                ]
              ) : Divider();
            }, childCount: 2,
          ),
        ),
        appBar: SliverAppBar(
          backgroundColor: Colors.white,
          snap: true,
          floating: true,
          elevation: 0.0,
          forceElevated: false,
          expandedHeight: kToolbarHeight * 1.2,
          leading: CloseButton(),
        ),
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
