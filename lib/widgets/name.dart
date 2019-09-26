import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/community.dart';
import 'package:cdr_today/widgets/alerts.dart';


// @usage: AvatarHero
class Name extends StatelessWidget {
  final bool self;
  final double size;
  final List<String> list;

  Name({ this.self = false, this.size, this.list });
  
  @override
  Widget build(BuildContext context) {
    Widget _name(List<String> arr) {
      if (arr == null) arr = ['?'];
      
      for (var i in arr) {
        if (i == null) continue;
        if (size != null) return Text(i, style: TextStyle(fontSize: size));

        return Text(i, style: Theme.of(context).textTheme.title);
      }

      return Text('?', style: Theme.of(context).textTheme.title);
    }

    if (!self) return _name(list);
    
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInited) {
          return list == null ? _name(
            [state.name]
          ) : _name(
            [state.name] + list
          );
        }

        return _name(['?']);
      }
    );
  }
}

class CommunityName extends StatelessWidget {
  final bool limit;
  final bool qr;
  CommunityName({this.limit = false, this.qr = false});
  
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityBloc, CommunityState>(
      builder: (context, state) {
        if (state is Communities) {
          String name;
          var cs = state.communities;
          for (var i in cs) {
            if (i['id'] == state.current) name = i['name'];
          }

          if (name == null) name = '';
          return GestureDetector(
            child: Container(
              child: AutoSizeText(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
                maxLines: 1,
              ),
              width: MediaQuery.of(context).size.width * 1 / 3,
            ),
            onTap: qr ? () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    content: Container(
                      child: Center(
                        child: QrImage(
                          data: "/c/${state.current}",
                          version: QrVersions.auto,
                          size: MediaQuery.of(context).size.width / 2,
                        ),
                      ),
                      height: MediaQuery.of(context).size.width / 2 + 100,
                      width: MediaQuery.of(context).size.width / 2 + 100,
                    ),
                  );
                },
              );
            } : () {},
          );
        }
        return Text('?');
      }
    );
  }
}
