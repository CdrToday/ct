import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/widgets/cards.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:cdr_today/widgets/refresh.dart';
import 'package:cdr_today/x/permission.dart' as pms;

class Bucket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: QrRefresher(
          widget: CtNoRipple(
            icon: CupertinoIcons.add_circled,
            onTap: () => Navigator.pushNamed(context, '/community/create')
          )
        ),
        border: null,
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
              if (await pms.checkCamera(context) == false) return;
              Navigator.pushNamed(context, '/scan');
            }
          )
        ],
      ),
      resizeToAvoidBottomInset: false
    );
  }
}
