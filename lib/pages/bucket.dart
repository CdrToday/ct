import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/cards.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/x/permission.dart' as pms;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/x/req.dart' as xReq;


class Bucket extends StatefulWidget {
  _BucketState createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  String _value = '';

  void changeValue(String value) {
    setState(() { _value = value; });
  }
  
  @override
  Widget build(BuildContext context) {
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
    final CommunityBloc _cbloc = BlocProvider.of<CommunityBloc>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: QrRefresher(
          widget: CtNoRipple(
            icon: CupertinoIcons.add_circled,
            onTap: () => Navigator.pushNamed(context, '/community/create')
          )
        ),
        leading: null,
        border: null,
        automaticallyImplyLeading: false,
      ),
      child: Column(
        children: [
          ProfileCard(),
          SizedBox(
            height: MediaQuery.of(context).size.height / 12
          ),
          CtOutlineButton(
            text: '加入社区',
            onTap: () async {
              showCupertinoModalPopup(
                context: context,
                builder: (ctx) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text('扫码'),
                      onPressed: () async {
                        if (await pms.checkCamera(context) == false) return;
                        Navigator.of(context, rootNavigator: true).pushNamed('/scan');
                      }
                    ),
                    CupertinoActionSheetAction(
                      child: Text('搜索'),
                      onPressed: () async {
                        Navigator.pop(context);
                        alertInput(
                          context,
                          title: '加入社区',
                          content: CupertinoTextField(
                            autofocus: true,
                            onChanged: changeValue,
                            style: TextStyle(fontSize: 16.0),
                            decoration: BoxDecoration(border: null),
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
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text('取消'),
                    onPressed: () => Navigator.pop(context)
                  ),
                )
              );
              
            }
          )
        ],
      ),
      resizeToAvoidBottomInset: false
    );
  }
}
