import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/widgets/tiles.dart';
import 'package:cdr_today/widgets/buttons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/db.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/x/store.dart' as store;

class Settings extends StatefulWidget {
  @override
  createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final DbBloc _bloc = BlocProvider.of<DbBloc>(context);
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
                    var db = store.CtDatabase();
                    await db.open();
                    await db.updateSettings(
                      'longArticle',
                      (state as Db).longArticle? 'false': 'true'
                    );
                    _bloc.dispatch(DbRefresh());
                  },
                ),
              ),
            ],
          );
        }
      )
    );
  }
}
