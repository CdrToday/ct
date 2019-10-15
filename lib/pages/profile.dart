import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/center.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/navigations/args.dart';

class Profile extends StatelessWidget {
  Widget build(BuildContext context) {
    final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              trailing: CtNoRipple(
                icon: CupertinoIcons.settings,
                onTap: () => Navigator.of(
                  context, rootNavigator: true
                ).pushNamed('/mine/settings')
              )
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  avatar(context),
                  profile(context, state.name),
                  mail(context, state.mail),
                ]
              ),
            ),
            resizeToAvoidBottomInset: false,
          );
        } else {
          _bloc.dispatch(CheckUserEvent());
          return Container(
            child: CenterX(x: '重新登录中...'),
            color: Colors.white
          );
        }
      }
    );
  }
}
  
Widget avatar(BuildContext context) {
  return Container(
    child: Card(
      child: ListTile(
        title: Text(
          '头像',
          style: TextStyle(color: CtColors.primary)
        ),
        trailing: AvatarHero(self: true),
        onTap: () => Navigator.of(context, rootNavigator: true).pushNamed('/mine/profile/avatar'),
      ),
      color: CtColors.gray6
    ),
  );
}

Widget profile(BuildContext context, String name) {
  return Container(
    child: Card(
      child: ListTile(
        title: Text(
          '名字',
          style: TextStyle(color: CtColors.primary)
        ),
        trailing: Text(
          name,
          style: TextStyle(color: CtColors.primary)
        ),
        onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
          '/mine/profile/name',
          arguments: NameArgs( name: name ),
        ),
      ),
      color: CtColors.gray6
    ),
  );
}

Widget mail(BuildContext context, String str) {
  return Builder(
    builder: (context) => Container(
      child: Card(
        child: ListTile(
          title: Text(
            '邮箱',
            style: TextStyle(color: CtColors.primary)
          ),
          trailing: Text(
            str,
            style: TextStyle(color: CtColors.primary)
          ),
        ),
        color: CtColors.gray6
      ),
    )
  );
}
