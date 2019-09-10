import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/article_list.dart';
import 'package:cdr_today/widgets/center.dart';


class Mine extends StatelessWidget {
  Widget build(BuildContext context) {
    final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return Column(
            children: <Widget>[
              header(),
              profile(context),
              articles(context),
              version(context),
              Spacer()
            ]
          );
        } else {
          _bloc.dispatch(CheckUserEvent());
          return CenterX(x: '重新登录中...');
        }
      }
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
    title: Text('个人信息'),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/profile')
  );
}

Widget articles(BuildContext context) {
  return ListTile(
    title: Text('文章管理'),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/article/manager')
  );
}

Widget version(BuildContext context) {
  return  ListTile(
    title: Text('版本信息'),
    onTap: () => Navigator.popAndPushNamed(context, '/mine/version')
  );
}
