import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateName extends StatelessWidget {
  final String name;
  final bool enabled;
  UpdateName({ this.name, this.enabled });

  static List<Widget> asList({String name}) {
    return [UpdateName(name: name)];
  }
  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final UserBloc _ubloc = BlocProvider.of<UserBloc>(context);
    return CtNoRipple(
      icon: enabled ? Icons.check : null,
      onTap: () async {
        if (!enabled) return;
        final xReq.Requests r = await xReq.Requests.init();
        bool valid = RegExp(r"^\S[\S\s]{1,11}$").hasMatch(name);
        if (!valid) {
          info(context, '用户名不能为空、或以空格开头, 长度应小于 12。');
          return;
        }

        _bloc.dispatch(Refresh(profile: true));
        var res = await r.updateName(name: name);
        if (res.statusCode != 200) {
          info(context, '更新失败，请重试');
          _bloc.dispatch(Refresh(profile: false));
          return;
        }

        _bloc.dispatch(Refresh(profile: false));
        _ubloc.dispatch(InitUserEvent(name: name, local: true));
        Navigator.pop(context);
      },
    );
  }
}

