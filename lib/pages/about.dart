import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/x/store.dart' as store;

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        // backgroundColor: CtColors.tp,
        border: null,
      ),
      child: Column(
        children: [
          ProfileTile(
            leading: '隐私政策',
            onTap: () async {
              var url = 'https://cdr-today.github.io/intro/privacy/zh.html';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          CtDivider(),
          ProfileTile(
            leading: '联系作者',
            onTap: () async {
              var url = 'mailto:cdr.today@foxmail.com?subject=hello';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          CtDivider(),
          ProfileTile(
            leading: '版本信息',
            onTap: () => Navigator.pushNamed(context, '/mine/version')
          ),
          CtDivider(),
          ProfileTile(
            leading: '检查更新',
            onTap: () async {
              var url = 'https://cdr-today.github.io/x/download';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            }
          ),
          SizedBox(height: 12.0),
          ProfileTile(
            leading: '退出账号',
            onTap: () async {
              alert(
                context,
                title: '退出当前账号?',
                action: () async {
                  final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
                  store.clear();
                  _bloc.dispatch(LogoutEvent());
                  Navigator.of(
                    context, rootNavigator: true
                  ).pushNamedAndRemoveUntil('/splash', (_) => false);
                }
              );
            }
          ),
        ],
      ),
    );
  }
}
