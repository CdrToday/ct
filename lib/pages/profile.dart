import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/post.dart';
import 'package:cdr_today/widgets/center.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/navigations/args.dart';

class Profile extends StatelessWidget {
  Widget build(BuildContext context) {
    final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return Scaffold(
            appBar: AppBar(leading: CloseButton()),
            body: Container(
              child: Column(
                children: <Widget>[
                  avatar(context),
                  profile(context, state.name),
                  Spacer(),
                  logout(context),
                ]
              ),
              padding: EdgeInsets.only(
                top: 20.0, left: 10.0, right: 10.0,
                bottom: kToolbarHeight
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
        title: Text('头像'),
        trailing: AvatarHero(self: true),
        onTap: () => Navigator.pushNamed(context, '/mine/profile/avatar'),
        contentPadding: EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 16.0
        )
      )
    ),
    margin: EdgeInsets.only(top: 10.0)
  );
}

Widget profile(BuildContext context, String name) {
  return Container(
    child: Card(
      child: ListTile(
        title: Text('名字'),
        trailing: Text(name),
        onTap: () => Navigator.pushNamed(
          context, '/mine/profile/name',
          arguments: NameArgs( name: name )
        )
      )
    ),
    margin: EdgeInsets.only(top: 10.0)
  );
}

Widget mail(BuildContext context, String str) {
  return Builder(
    builder: (context) => Container(
      child: Card(
        child: ListTile(
          title: Text('邮箱'),
          trailing: Text(str),
        )
      ),
      margin: EdgeInsets.only(top: 10.0)
    )
  );
}

Widget logout(BuildContext context) {
  final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
  final PostBloc _pbloc = BlocProvider.of<PostBloc>(context);
  
  return Container(
    child: Center(
      child: GestureDetector(
        child: Text(
          '退出登录',
          style: TextStyle(fontSize: 14.0)
        ),
        onTap: () async {
          _pbloc.dispatch(CleanList());
          _bloc.dispatch(LogoutEvent());
          Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
        }
      )
    ),
    margin: EdgeInsets.only(top: 20.0)
  );
}
