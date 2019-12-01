import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/member.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/community.dart';
import 'package:cdr_today/navigations/args.dart';

class CommunityMember extends StatelessWidget {
  final SliverAppBar appBar;
  CommunityMember({ this.appBar });
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // appBar,
        BlocBuilder<MemberBloc, MemberState>(
          builder: (context, state) {
            if (state is Members) {
              var ms = state.members;
              if (ms.length > 0) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == 0) return SizedBox(height: 8.0);
                      return index.isOdd ? CommunityTile(
                        avatar: Avatar(
                          width: 20.0,
                          url: ms[index ~/ 2]['avatar'],
                          baks: [
                            ms[index ~/ 2]['name'],
                          ]
                        ),
                        name: (ms[index ~/ 2]['name']),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        onTap: () => Navigator.of(
                          context, rootNavigator: true
                        ).pushNamed(
                          '/post',
                          arguments: PostArgs(
                            ident: ms[index ~/ 2]['mail'],
                            community: state.id,
                          )
                        )
                      ) : Divider(
                        indent: 20.0,
                        endIndent: 20.0
                      );
                    },
                    childCount: state.members.length * 2,
                  )
                );
              }
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return SizedBox.shrink();
                }
              )
            );
          }
        ),
        SliverPadding(padding: EdgeInsets.all(8.0))
      ]
    );
  }
}
