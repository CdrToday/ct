import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/bar.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/name.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/widgets/community.dart';

class SwipeCommunity extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        title: CommunityRefresher(),
      ),
      body: Column(
        children: <Widget>[
          header(context),
          DrawerBar(
            title: '社区',
            icon: Icons.add_circle_outline,
            action: () => Navigator.pushNamed(context, '/community/raise')
          ),
          CommunityList(),
        ],
      )
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
            self: true, width: 30.0, tag: flag == true ? 'nil' : '',
            onTap: flag == true ? () => Navigator.pop(
              context
            ) : () => Navigator.pushNamed(context, '/mine/bucket'),
          ),
          SizedBox(height: 15.0),
          Name(self: true, size: 18.0),
          SizedBox(height: 30.0),
        ]
      );
    }
  );
}
