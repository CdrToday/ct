import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/community.dart';

class CommunityMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is CommunityFetchedSucceed) {
          dynamic community;
          var cs = state.communities;
          for (var i in cs) {
            if (i['id'] == state.current) community = i;
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) return SizedBox(height: 8.0);
                
                return index.isOdd ? Container(
                  child: CommunityTile(
                    avatar: AvatarHero(width: 20.0),
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 8.0,
                    )
                  )
                ) : Divider();
              }
            )
          );
        }
        return SizedBox.shrink();
      }
    );
  }
}
