import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/navigations/args.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Join extends StatelessWidget {
  final QrCodeArgs args;
  Join({ this.args });

  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
    final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);
  
    Widget check = Padding(
      child: CupertinoRefresher(
        widget: GestureDetector(
          child: Icon(Icons.check),
          onTap: () async {
            final r = await xReq.Requests.init();

            _rbloc.dispatch(Refresh(cupertino: true));
            var res = await r.joinCommunity(id: args.code);
            
            if (res.statusCode != 200) {
              snacker(context, '加入失败，请重试');
              return;
            } else {
              print(json.decode(res.body)['msg']);
              _rbloc.dispatch(Refresh(cupertino: false));
              _rbloc.dispatch(CommunityRefresh());
              _cbloc.dispatch(FetchCommunities());
              Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
            }

            return;
          }
        ),
      ),
      padding: EdgeInsets.only(right: 16.0)
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          CupertinoRefresher(widget: check)
        ],
        leading: CloseButton(),
      ),
      body: Center(
        child: Container(
          child: AutoSizeText(
            '加入 ${args.code} ?',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context).textTheme.display1
          ),
          padding: EdgeInsets.only(bottom: kToolbarHeight),
          width: MediaQuery.of(context).size.width - 50,
        )
      )
    );
  }
}
