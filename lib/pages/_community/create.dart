import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String _name = '';
  
  void changeName(String value) {
    setState(() { _name = value; });
  }
  
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('创建社区'),
        leading: CtClose(),
        border: null,
        trailing: CupertinoRefresher(
          widget: CtNoRipple(
            icon: Icons.check,
            onTap: () => createCommunity(context),
          )
        ),
      ),
      child: Column(
        children: [
          Input(helper: '请输入社区名称', onChanged: changeName)
        ],
      ),
    );
  }

  void createCommunity(BuildContext context) async {
    final xReq.Requests r = await xReq.Requests.init();
    final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);

    if (!RegExp(r"^\S{1,10}$").hasMatch(_name)) {
      info(context, '社区名不能为空，长度应小于 10');
      return;
    }
    
    _rbloc.dispatch(Refresh(cupertino: true));
    var res = await r.createCommunity(name: _name);
    if (res.statusCode != 200) {
      info(context, '创建失败，请重试');
      _rbloc.dispatch(Refresh(cupertino: false));
      return;
    }

    _rbloc.dispatch(Refresh(cupertino: false));
    _rbloc.dispatch(CommunityRefresh());
    _cbloc.dispatch(FetchCommunities());
    Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
  }
}
