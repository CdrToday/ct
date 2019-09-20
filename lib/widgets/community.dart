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
          ]
        ),
        onTap: onTap
      ),
      padding: padding
    );
  }
}


class Communities extends StatefulWidget {
  @override
  _CommunitiesState createState() => _CommunitiesState();
}

class _CommunitiesState extends State<Communities> {
  List<dynamic> communities;
  CommunityBloc _bloc;
  RefreshBloc _rbloc;
  bool _scrollLock = false;
  double _scrollThreshold = 200.0;
  double _scrollIncipiency = (- kToolbarHeight);
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _bloc = BlocProvider.of<CommunityBloc>(context);
    _rbloc = BlocProvider.of<RefreshBloc>(context);
  }
  
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is EmptyCommunityState) {
          _bloc.dispatch(FetchCommunity());
          _rbloc.dispatch(CommunityRefreshEvent());
          return SizedBox.shrink();
        } else if (state is CommunityFetchedSucceed) {
          var cs = state.communities;
          return Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index.isEven) {
                        var i = index ~/ 2;
                        return CommunityTile(
                          name: Text(cs[i]['name']),
                          avatar: AvatarHero(
                            tag: cs[i]['id'],
                            rect: true,
                          ),
                          padding: index == 0 ?
                          EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 8.0
                          ) : EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)
                        );
                      }

                      return Divider();
                    },
                    childCount: state.communities.length * 2 - 1
                  )
                )
              ],
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
            )
          );
        }
        return SizedBox.shrink();
      }
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    BehaviorSubject scrollDelay = BehaviorSubject();
    
    // top refresh
    if (currentScroll <= _scrollIncipiency) {
      if (_scrollLock == true) {
        return;
      }
    
      setState(() { _scrollLock = true; });

      _bloc.dispatch(FetchCommunity(refresh: true));
      _rbloc.dispatch(CommunityRefreshEvent());
      
      Observable.timer(
        false, new Duration(milliseconds: 1000)
      ).listen((i) => setState(() { _scrollLock = i; }));
    }
  }
}
