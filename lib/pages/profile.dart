import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/center.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/navigations/args.dart';

class Profile extends StatelessWidget {
  final bool raw;
  Profile({ this.raw = false });
  
  Widget build(BuildContext context) {
    final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
    // final double _kTileHeight = 48.0;
    
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: raw ? CtClose() : null,
              border: null
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  ProfileTile(
                    leading: '头像',
                    trailing: AvatarHero(self: true),
                    onTap: () => Navigator.of(
                      context, rootNavigator: true
                    ).pushNamed('/mine/profile/avatar'),
                  ),
                  CtDivider(),
                  ProfileTile(
                    leading: '名字',
                    trailing: Text(
                      state.name,
                      style: TextStyle(color: CtColors.primary)
                    ),
                    onTap: () => Navigator.of(
                      context, rootNavigator: true
                    ).pushNamed(
                      '/mine/profile/name',
                      arguments: NameArgs( name: state.name ),
                    ),
                  ),
                  CtDivider(),
                  ProfileTile(
                    leading: '邮箱',
                    trailing: Text(
                      state.mail,
                      style: TextStyle(color: CtColors.primary)
                    ),
                  ),
                  SizedBox(height: 12.0),
                  BlocBuilder<CommunityBloc, CommunityState>(
                    builder: (context, cState) => ProfileTile(
                      leading: '文章',
                      onTap: () => Navigator.of(
                        context, rootNavigator: true
                      ).pushNamed('/post', arguments: PostArgs(
                          ident: state.mail,
                          community: (cState as Communities).current
                        )
                      ),
                    )
                  ),
                  CtDivider(),
                  ProfileTile(
                    leading: '设置',
                    onTap: () => Navigator.of(
                      context, rootNavigator: true
                    ).pushNamed('/mine/settings'),
                  ),
                  SizedBox(height: 12.0),
                  ProfileTile(
                    leading: '关于',
                    onTap: () => Navigator.of(
                      context, rootNavigator: true
                    ).pushNamed('/mine/about'),
                  ),
                  
                ]
              ),
            ),
            resizeToAvoidBottomInset: false,
          );
        } else {
          _bloc.dispatch(CheckUserEvent());
          return Container(
            child: CenterX(x: '重新登录中...'),
          );
        }
      }
    );
  }
}
