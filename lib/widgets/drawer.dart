import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/blocs/user.dart';

class MainDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header(context),
        // version(context),
        Spacer()
      ],
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return Container(
    child: DrawerHeader(
      child: Row(
        children: [
          AvatarHero(
            rect: true,
            tag: 'mine',
            width: 24.0,
            onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket'),
          ),
          SizedBox(width: 10.0),
          BlocBuilder<UserBloc, UserState>(
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
          Spacer(),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: Colors.black,
            onPressed: () => Navigator.pushNamed(context, '/scan')
          ),
        ],
      ),
    ),
    height: kToolbarHeight * 3,
  );
}
