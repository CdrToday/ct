import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/input.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class Join extends StatefulWidget {
  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  String _id = '';
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('加入社区'),
        leading: CloseButton(),
        actions: [
          GestureDetector(
            child: Container(
              child: Icon(Icons.check),
              padding: EdgeInsets.only(right: 16.0)
            ),
            onTap: () async {
              final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);
              var r = await xReq.Requests.init();
              var res = await r.joinCommunity(id: _id);
              if (res.statusCode != 200) {
                snacker(context, '加入失败，请重试');
                return;
              }
              
              _cbloc.dispatch(FetchCommunities());
              Navigator.pushNamedAndRemoveUntil(context, '/root', (_) => false);
            }
          ),
        ],
      ),
      body: Input(
        helper: '请输入社区 ID',
        onChanged: (value) => setState(() { _id = value; })
      ),
      backgroundColor: Theme.of(context).primaryColorLight,
    );
  }
} 
