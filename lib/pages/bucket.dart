import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Bucket extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Post(
        edit: true,
        appBar: SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          snap: true,
          elevation: 0.4,
          forceElevated: true,
          expandedHeight: kToolbarHeight * 4,
          leading: CloseButton(),
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
          actions: [ blog() ],
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
              child: AvatarHero(
                tag: 'mine',
                width: 22.0,
                onTap: () => Navigator.pushNamed(context, '/mine/profile'),
              ),
              padding: EdgeInsets.only(bottom: kToolbarHeight / 1.5)
            ),
          )
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
          icon: Icon(Icons.public),
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
