import 'package:flutter/material.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfile extends StatelessWidget {
  final String id;
  final String input;
  final String profile;
  final bool enabled;
  final BuildContext sContext;

  UpdateProfile({
      this.input,
      this.enabled,
      this.profile = 'name',
      this.id = '',
      this.sContext,
  });
  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _bloc = BlocProvider.of<RefreshBloc>(context);
    final UserBloc _ubloc = BlocProvider.of<UserBloc>(context);
    final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);
    return CtNoRipple(
      icon: enabled ? Icons.check : null,
      onTap: () async {
        if (!enabled) return;
        final xReq.Requests r = await xReq.Requests.init();
        bool valid = RegExp(r"^\S[\S\s]{1,11}$").hasMatch(input);
        if (!valid) {
          info(
            context, profile == 'id'
            ? 'id 不能为空、或以空格开头, 长度应小于 12。'
            : '名字不能为空、或以空格开头, 长度应小于 12。'
          );
          return;
        }

        _bloc.dispatch(Refresh(profile: true));

        var res;
        if (profile == 'name') {
          res = await r.updateName(name: input);
        } else if (profile == 'community') {
          res = await r.updateCommunityName(name: input, id: id);
        } else {
          // res = await r.updateCommunityId(idTarget: input, id: id);
        }
        
        if (res.statusCode != 200) {
          _bloc.dispatch(Refresh(profile: false));
          info(sContext, '更新失败，请重试');
          return;
        }

        _bloc.dispatch(Refresh(profile: false));
        if (profile == 'name') {
          _ubloc.dispatch(InitUserEvent(name: input, local: true));
        } else {
          _cbloc.dispatch(RefreshCommunities());
        }
        Navigator.pop(context);
      },
    );
  }
}

