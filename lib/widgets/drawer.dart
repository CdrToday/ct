import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/community.dart';
import 'package:cdr_today/blocs/user.dart';

class MainDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
      ),
      body: Column(
        children: <Widget>[
          header(context),
          // version(context),
          Spacer(),
          Divider(),
          Text('创建社区'),
          SizedBox(height: kToolbarHeight * 2)
        ],
      )
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return Container(
    child: DrawerHeader(
      child: CommunityTile(
        avatar: AvatarHero(
          rect: true,
          tag: 'mine',
          width: 24.0,
          onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket'),
        ),
        name: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInited) {
              return Text(
                state.name,
                style: Theme.of(context).textTheme.title,
              );
            }
            return SizedBox.shrink();
          }
        ),
        action: IconButton(
          icon: Icon(Icons.add_circle_outline),
          color: Colors.black,
          onPressed: () => Navigator.pushNamed(context, '/scan')
        )
      ),
    ),
    height: kToolbarHeight * 3,
  );
}
