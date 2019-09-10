import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/blocs/article_list.dart';
import 'package:cdr_today/widgets/modify.dart';

class Profile extends StatelessWidget {
  Widget build(BuildContext context) {
    final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return Scaffold(
            appBar: AppBar(
              title: Text('个人信息'),
              leading: CloseButton()
            ),
            body: ListView(
              padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
              children: <Widget>[
                profile(context, state.name),
                mail(context, state.mail),
                logout(context),
              ]
            )
          );
        } else {
          _bloc.dispatch(CheckUserEvent());
          return Center(child: Text('重新登录中...'));
        }
      }
    );
  }
}

Widget profile(BuildContext context, String name) {
  return BlocListener<ProfileBloc, ProfileState>(
    listener: (context, state) {
      final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
      if (state is ProfileUpdatingSucceed) {
        _bloc.dispatch(InitUserEvent(mail: state.mail, name: state.name));
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("用户名修改成功"),
            duration: Duration(seconds: 1)
          ),
        );
      } else if (state is ProfileUpdatingFailed) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("用户名已被使用" ),
            duration: Duration(seconds: 1)
          ),
        );
      }
    },
    child: Container(
      child: Card(
        child: ListTile(
          title: Text('名字'),
          trailing: Text(name),
          onTap: () => _neverSatisfied(context, '名字', 'name'),
        )
      ),
      margin: EdgeInsets.only(top: 10.0)
    )
  );
}

Widget mail(BuildContext context, String str) {
  return Builder(
    builder: (context) => Container(
      child: Card(
        child: ListTile(
          title: Text('邮箱'),
          trailing: Text(str),
          onTap: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("修改邮箱请前往官网: 'https://cdr.today/reborn' 🦄️" ),
                duration: Duration(seconds: 1)
              ),
            );
          }
        )
      ),
      margin: EdgeInsets.only(top: 10.0)
    )
  );
}

Widget logout(BuildContext context) {
  final UserBloc _bloc = BlocProvider.of<UserBloc>(context);
  final ArticleListBloc _albloc = BlocProvider.of<ArticleListBloc>(context);
  
  return Container(
    child: Center(
      child: GestureDetector(
        child: Text(
          '退出登录',
          style: TextStyle(fontSize: 14.0)
        ),
        onTap: () {
          _bloc.dispatch(LogoutEvent());
          Navigator.pop(context);
          _albloc.dispatch(CleanList());
        }
      )
    ),
    margin: EdgeInsets.only(top: 20.0)
  );
}

// -------------- modal ---------------
Future<void> _neverSatisfied(
  BuildContext context, String title, String index
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ModifyDialog(title: title, index: index);
    },
  );
}
