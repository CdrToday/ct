import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/req.dart' as xReq;
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/x/_style/text.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/buttons.dart';
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
    _rbloc.dispatch(Refresh(cupertino: false));
    
    Widget check = CupertinoRefresher(
      widget: GestureDetector(
        child: Icon(Icons.check, size: 22.0),
        onTap: () async {
          final r = await xReq.Requests.init();

          _rbloc.dispatch(Refresh(cupertino: true));
          var res = await r.joinCommunity(id: args.code);
          
          if (res.statusCode != 200) {
            info(context, '加入失败，请重试');
            _rbloc.dispatch(Refresh(cupertino: false));
            return;
          } else {
            _rbloc.dispatch(Refresh(cupertino: false));
            _rbloc.dispatch(CommunityRefresh());
            _cbloc.dispatch(FetchCommunities());
            Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
          }

          return;
        }
      ),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: check,
        leading: CtClose(),
        border: null,
      ),
      child: Center(
        child: Container(
          child: AutoSizeText(
            '加入 "${args.name}" ?',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              color: CtColors.primary,
              fontSize: CtFontSize.title
            ),
          ),
          padding: EdgeInsets.only(bottom: kToolbarHeight),
          width: MediaQuery.of(context).size.width - 50,
        )
      )
    );
  }
}
