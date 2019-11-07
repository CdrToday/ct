import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/x/permission.dart' as pms;

enum Action { scan, create, search }

class CommunityPopMenu extends StatefulWidget {
  final Widget child;
  CommunityPopMenu({ this.child });
  _CommunityPopMenuState createState() => _CommunityPopMenuState();
}

class  _CommunityPopMenuState extends State<CommunityPopMenu> {
  String _value = '';

  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
    final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);
    
    return Material(
      child: PopupMenuButton<Action>(
        child: widget.child,
        onSelected: (Action result) async {
          if (result == Action.scan) {
            if (await pms.checkCamera(context) == false) return;
            Navigator.of(context, rootNavigator: true).pushNamed('/scan');
          } else if (result == Action.create) {
            Navigator.of(context, rootNavigator: true).pushNamed('/community/create');
          } else {
            alertInput(
              context,
              title: '加入社区',
              content: Container(
                child: CupertinoTextField(
                  autofocus: true,
                  onChanged: changeValue,
                  style: TextStyle(fontSize: 16.0),
                  decoration: BoxDecoration(border: null),
                ),
                color: CtColors.gray7,
                margin: EdgeInsets.only(top: 8.0),
              ),
              ok: Text('加入'),
              action: () async {
                final r = await xReq.Requests.init();
                _rbloc.dispatch(Refresh(cupertino: true));
                var res = await r.joinCommunity(id: _value);
                if (res.statusCode != 200) {
                  info(context, '加入失败，请重试');
                  return;
                } else {
                  _rbloc.dispatch(Refresh(cupertino: false));
                  _rbloc.dispatch(CommunityRefresh());
                  _cbloc.dispatch(FetchCommunities());
                  Navigator.of(context, rootNavigator: true).pop();
                }

                return;
              }
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Action>>[
          PopupMenuItem<Action>(
            value: Action.scan,
            child: Text(
              '扫码',
              style: TextStyle(color: CtColors.primary)
            ),
          ),
          PopupMenuItem<Action>(
            value: Action.search,
            child: Text(
              '搜索',
              style: TextStyle(color: CtColors.primary)
            ),
          ),
          PopupMenuItem<Action>(
            value: Action.create,
            child: Text(
              '创建',
              style: TextStyle(color: CtColors.primary)
            ),
          ),
        ],
        color: CtColors.gray6
      ),
      color: CtColors.gray5
    );
  }
}
