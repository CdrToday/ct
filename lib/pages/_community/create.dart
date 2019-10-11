import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  String _id;
  String _name;
  
  void changeId(String value) {
    setState(() { _id = value; });
  }

  void changeName(String value) {
    setState(() { _name = value; });
  }
  
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('创建社区'),
        border: null,
        // backgroundColor: CtColors.transparent
      ),
      child: Column(
        children: [
          Input(helper: '请输入社区名称', onChanged: changeName)
        ],
      ),
    );
  }

  createCommunity(BuildContext context) async {
    final xReq.Requests r = await xReq.Requests.init();
    final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
    
    if (!RegExp(r"^[a-zA-Z0-9_]{1,20}$").hasMatch(_id)) {
      snacker(context, '社区 ID 只能使用字母数字与下划线 "_"，长度需小于 20', secs: 2);
      return;
    }

    if (!RegExp(r"^\S{1,10}$").hasMatch(_name)) {
      snacker(context, '社区名不能为空，或以空格开头，长度应小于 10', secs: 2);
      return;
    }

    _rbloc.dispatch(Refresh(cupertino: true));
    var res = await r.createCommunity(id: _id, name: _name);
    if (res.statusCode != 200) {
      snacker(context, '创建失败，请更换社区 ID 后重试');
      _rbloc.dispatch(Refresh(cupertino: false));
      return;
    }

    _rbloc.dispatch(Refresh(cupertino: false));
    _rbloc.dispatch(CommunityRefresh());
    _cbloc.dispatch(FetchCommunities());
    Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
  }
}
