import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/avatar.dart';
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
  
  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<CommunityBloc>(context);
    _bloc.dispatch(FetchCommunity());
  }
  
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        
        if (state is CommunityFetchedSucceed) {
          var cs = state.communities;
          return Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return CommunityTile(
                        name: Text(cs[index]['name']),
                        avatar: AvatarHero(tag: cs[index]['id']),
                        padding: EdgeInsets.all(16.0)
                      );
                    },
                    childCount: state.communities.length
                  )
                )
              ]
            )
          );
        }
        return SizedBox.shrink();
      }
    );
  }
}
