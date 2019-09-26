import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/x/req.dart' as xReq;

// members' view
class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
      ),
      body: BlocBuilder<CommunityBloc, CommunityState>(
        builder: (context, state) {
          if (state is Communities) {
            var cs = state.communities;
            var community;
            for (var i in cs) {
              if (i['id'] == state.current) community = i;
            }
            
            return Column(
              children: [
                Tile(
                  title: Text('id'),
                  trailing: Text(community['id']),
                ),
                Tile(
                  title: Text('名字'),
                  trailing: Text(community['name']),
                ),
                Spacer(),
                Builder(
                  builder: (context) => quit(context, community['id'])
                ),
                SizedBox(height: kToolbarHeight),
              ]
            );
          }
          return SizedBox.shrink();
        }
      )
    );
  }
}

// TODO: Owner's view
// ...

// common
Widget quit(BuildContext context, String id) {
  return Container(
    child: Center(
      child: GestureDetector(
        child: Text(
          '退出社区',
          style: TextStyle(fontSize: 14.0)
        ),
        onTap: () => alert(
          context,
          title: '退出社区?',
          action: () async {
            final xReq.Requests r = await xReq.Requests.init();
            var res = await r.quitCommunity(id: id);
            
            if (res.statusCode != 200) {
              print(res.statusCode);
              snacker(context, '退出失败，请重试');
              Navigator.pop(context);
              return;
            }

            final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
            final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);

            _rbloc.dispatch(CommunityRefresh());
            _cbloc.dispatch(FetchCommunities());
            Navigator.pushNamedAndRemoveUntil(context, '/init', (_) => false);
            // Navigator.maybePop(context);
            // Navigator.maybePop(context);
          }
        )
      )
    ),
    margin: EdgeInsets.only(top: 20.0)
  );
}
