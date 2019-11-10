import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/community.dart';
import 'package:cdr_today/widgets/_actions/pop.dart';

class CommunityListPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: CommunityRefresher(widget: Text('社区')),
        leading: CtNoRipple(
          icon: Icons.insert_emoticon,
          onTap: () => Navigator.of(
            context, rootNavigator: true
          ).pushNamed('/community/member')
        ),
        trailing: CommunityPopMenu(
          child: CtNoRipple(icon: Icons.add_circle_outline),
        ),
        border: null,
      ),
      child: Column(
        children: <Widget>[
          CommunityList(),
        ],
      ),
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return BlocBuilder<CommunityBloc, CommunityState>(
    builder: (context, state) {
      bool flag = false;
      if ((state is Communities) && state.current == '') flag = true;

      return Column(
        children: [
          SizedBox(height: 5.0),
          AvatarHero(
            self: true,
            width: 30.0,
            tag: flag == true ? 'nil' : null,
            onTap: flag == true ? () => Navigator.pop(
              context
            ) : () => Navigator.pushNamed(context, '/mine/profile'),
          ),
          SizedBox(height: 15.0),
          Name(self: true, size: 18.0),
          SizedBox(height: 30.0),
        ]
      );
    }
  );
}
