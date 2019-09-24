import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateName extends StatelessWidget {
  final String name;
  UpdateName({ this.name });

  static List<Widget> asList({String name}) {
    return [UpdateName(name: name)];
  }
  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final UserBloc _ubloc = BlocProvider.of<UserBloc>(context);
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        final xReq.Requests r = await xReq.Requests.init();
        bool valid = RegExp(r"^[\u4e00-\u9fa5_a-zA-Z0-9]{0,10}$").hasMatch(name);
        if (!valid) {
          snacker(
            context,
            '用户名可使用中文，数字，英文字母及下划线 "_", 长度应小于 10。',
            secs: 2
          );
          return;
        }


        ///////
        _bloc.dispatch(Refresh(profile: true));
        ///////

        var res = await r.updateName(name: name);
        if (res.statusCode != 200) {
          snacker(context, '更新失败，请重试');
          return;
        }

        ///////
        _bloc.dispatch(Refresh(profile: false));
        _ubloc.dispatch(InitUserEvent(name: name));
        ///////

        Navigator.pop(context);
      }
    );
  }
}

