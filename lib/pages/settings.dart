import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/db.dart';
import 'package:cdr_today/x/_style/color.dart';

class Settings extends StatefulWidget {
  @override
  createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _longArticles = false;
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CtClose(),
        // backgroundColor: CtColors.tp,
        border: null,
      ),
      child: BlocBuilder<DbBloc, DbState>(
        builder: (context, state) {
          return Column(
            children: [
              ProfileTile(
                leading: '只看长文章',
                trailing: CupertinoSwitch(
                  value: (state as Db).longArticle,
                  activeColor: CtColors.gray3,
                  onChanged: (bool value) async {
                    
                  },
                ),
                onTap: () async {
                  var url = 'https://cdr-today.github.io/intro/privacy/zh.html';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              ),
            ],
          );
        }
      )
    );
  }
}
