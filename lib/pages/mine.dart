import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cdr_today/x/store.dart';
import 'package:cdr_today/blocs/user.dart';

class Mine extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header(),
        profile(context),
        articles(context),
        blog(context),
        author(context),
        version(context),
        Spacer()
      ],
    );
  }
}

// ----------- tiles -------------
Widget header() {
  return DrawerHeader(
    child: Center(child: Icon(Icons.gesture, color: Colors.black, size: 50.0))
  );
}

Widget profile(BuildContext context) {
  return  ListTile(
    title: Text(
      '个人信息',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/profile')
  );
}

Widget articles(BuildContext context) {
  return ListTile(
    title: Text(
      '文章管理',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/bucket')
  );
}

Widget blog(BuildContext context) {
  final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state){
      if (state is UserInited) {
        return ListTile(
          title: Text(
            '我的博客',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subhead,
          ),
          onTap: () async {
            await launch('https://${state.name}.cdr.today');
          }
        );
      }
      return SizedBox.shrink();
    }
  );
}

Widget author(BuildContext context) {
  return ListTile(
    title: Text(
      '联系作者',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () async {
      var url = 'mailto:cdr.today@foxmail.com?subject=hello';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  );
}

Widget version(BuildContext context) {
  return  ListTile(
    title: Text(
      '版本信息',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/version')
  );
}
