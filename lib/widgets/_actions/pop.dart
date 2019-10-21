import 'package:flutter/material.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/x/permission.dart' as pms;

enum Action { scan, create }

class CommunityPopMenu extends StatefulWidget {
  final Widget child;
  CommunityPopMenu({ this.child });
  _CommunityPopMenuState createState() => _CommunityPopMenuState();
}

class  _CommunityPopMenuState extends State<CommunityPopMenu> {
  Action _selection;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopupMenuButton<Action>(
        child: widget.child,
        onSelected: (Action result) async {
          if (result == Action.scan) {
            if (await pms.checkCamera(context) == false) return;
            Navigator.of(context, rootNavigator: true).pushNamed('/scan');
          } else {
            Navigator.of(context, rootNavigator: true).pushNamed('/community/create');
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Action>>[
          PopupMenuItem<Action>(
            value: Action.scan,
            child: Text('扫码', textAlign: TextAlign.center),
          ),
          PopupMenuItem<Action>(
            value: Action.create,
            child: Text('创建', textAlign: TextAlign.center),
          ),
        ],
        color: CtColors.gray6
      ),
      color: CtColors.gray5
    );
  }
}
