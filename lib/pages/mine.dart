import 'package:flutter/material.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/navigations/args.dart';

class Mine extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return ListView(
            padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            children: <Widget>[
              mail(context, state.mail),
              logout(context),
            ]
          );
        }
      }
    );
  }
}

Widget mail(BuildContext context, String str) {
  return Builder(
    builder: (context) => Card(
      child: ListTile(
        title: Text('邮箱'),
        trailing: Text(str),
        onTap: () {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                "修改邮箱请前往官网: 'https://cdr.today/reborn' 🦄️"
              ),
            ),
          );
        }
      )
    )
  );
}

Widget logout(BuildContext context) {
  final UserBloc _bloc = BlocProvider.of<UserBloc>(context);

  return Container(
    child: Center(
      child: GestureDetector(
        child: Text('退出登录', style: TextStyle(color: Theme.of(context).primaryColor)),
        onTap: () => _bloc.dispatch(LogoutEvent())
      )
    ),
    margin: EdgeInsets.only(top: 10.0)
  );
}
