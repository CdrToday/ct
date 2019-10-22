import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/x/_style/color.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        backgroundColor: CtColors.tp,
        border: null,
      ),
      child: Column(
        children: [
          BasicTile(
            text: '服务条款',
            onTap: () async {
              var url = 'https://cdr-today.github.io/intro/privacy/zh.html';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          BasicTile(
            text: '联系作者',
            onTap: () async {
              var url = 'mailto:cdr.today@foxmail.com?subject=hello';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          BasicTile(
            text: '版本信息',
            onTap: () => Navigator.pushNamed(context, '/mine/version')
          ),
          BasicTile(
            text: '退出登录',
            onTap: () {
              final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
              _bloc.dispatch(LogoutEvent());
              Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
            }
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center
      ),
      // extendBodyBehindAppBar: true,
    );
  }
}
