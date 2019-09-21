import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cdr_today/x/req.dart' as xReq;

class CommunityTile extends StatelessWidget {
  final Widget avatar;
  final Widget name;
  final Widget trailing;
  final VoidCallback onTap;
  final EdgeInsets padding;

  CommunityTile({ this.avatar, this.name, this.trailing, this.onTap, this.padding });
  
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Row(
          children: [
            avatar ?? SizedBox.shrink(),
            SizedBox(width: 10.0),
            name ?? SizedBox.shrink(),
            Spacer(),
            trailing ?? SizedBox.shrink(),
          ],
        ),
        onTap: onTap,
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}

class Communities extends StatelessWidget {
  Widget build(BuildContext context) {
    final CommunityBloc _bloc = BlocProvider.of<CommunityBloc>(context);
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is EmptyCommunityState) {
          return SizedBox.shrink();
        } else if (state is CommunityFetchedSucceed) {
          var cs = state.communities;
          return Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == 0) return SizedBox(height: 8.0);

                      if (index.isOdd) {
                        var i = index ~/ 2;
                        var tile = CommunityTile(
                          name: Text(cs[i]['name']),
                          avatar: AvatarHero(tag: cs[i]['id'], rect: true),
                        );

                        return cs[i]['id'] == state.current ? Stack(
                          children: [
                            tile,
                            Container(
                              width: 3.0,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.all(Radius.circular(90)),
                              ),
                            ),
                          ],
                          alignment: Alignment.centerLeft,
                        ) : GestureDetector(
                          child: tile,
                          onTap: () {
                            _rbloc.dispatch(CommunityRefreshTrigger());
                            _bloc.dispatch(ChangeCurrentCommunity(id: cs[i]['id']));
                          }
                        );
                      }
                      return Divider();
                    },
                    childCount: state.communities.length * 2
                  )
                )
              ],
              physics: AlwaysScrollableScrollPhysics(),
            )
          );
        }
        return SizedBox.shrink();
      }
    );
  }
}
