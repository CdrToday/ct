import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CommunityTile extends StatelessWidget {
  final Widget avatar;
  final String name;
  final Widget trailing;
  final VoidCallback onTap;
  final EdgeInsets padding;

  CommunityTile({ this.avatar, this.name, this.trailing, this.onTap, this.padding });
  
  Widget build(BuildContext context) {
    String _name = name;
    List<String> _nl = [
      'David Bowie',
      'Iggy Pop',
      'Lou Reed',
      'Kurt Cobain',
      'Bob Dylan',
      'John Lennon',
      'Patti Smith',
      'Joan Baez',
      'Donovan',
      'Chunk Berry',
      'Elvis Presley',
      'Leonard Cohen',
      'Rodriguez',
      'Neil Young'
    ];
    if (_name == '') {
      var rng = new Random();
      _name = _nl[rng.nextInt(13)];
    }
    return Container(
      child: GestureDetector(
        child: Row(
          children: [
            avatar ?? SizedBox.shrink(),
            SizedBox(width: 10.0),
            Expanded(
              child: AutoSizeText(
                _name,
                maxLines: 1,
                style: TextStyle(fontSize: 18),
              ),
            ) ?? SizedBox.shrink(),
            trailing != null ? Spacer() : SizedBox.shrink(),
            trailing ?? SizedBox.shrink(),
          ],
        ),
        onTap: onTap,
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}

class CommunityList extends StatelessWidget {
  Widget build(BuildContext context) {
    final CommunityBloc _bloc = BlocProvider.of<CommunityBloc>(context);
    final RefreshBloc _rbloc = BlocProvider.of<RefreshBloc>(context);
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is Communities) {
          var cs = state.communities;
          if (cs.length == 0) return SizedBox.shrink();
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
                          name: cs[i]['name'],
                          avatar: AvatarHero(
                            baks: [
                              cs[i]['name'],
                              cs[i]['id']
                            ],
                            tag: cs[i]['id'],
                            rect: true
                          ),
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
                            _rbloc.dispatch(CommunityRefresh());
                            _bloc.dispatch(ChangeCurrentCommunity(id: cs[i]['id']));
                          }
                        );
                      }
                      return Divider(indent: 16.0, endIndent: 16.0);
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
