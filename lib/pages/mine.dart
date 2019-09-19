import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/blocs/user.dart';


class Mine extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: CloseButton(),
        actions: [ blog() ],
      ),
      body: Column(
        children: <Widget>[
          header(context),
          Divider(),
          articles(context),
          // community(context),
          // Divider(),
          // author(context),
          // version(context),
          Spacer()
        ],
      )
    );
  }
}

// ----------- tiles -------------
Widget header(BuildContext context) {
  return Container(
    child: AvatarHero(
      tag: 'mine',
      width: 32.0,
      onTap: () => Navigator.pushNamed(context, '/mine/profile'),
    ),
    alignment: Alignment.center,
    padding: EdgeInsets.only(
      top: kToolbarHeight / 2,
      bottom: kToolbarHeight
    )
  );
}

Widget articles(BuildContext context) {
  return CupertinoActionSheetAction(
    child: Text(
      '文章管理',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onPressed: () => Navigator.popAndPushNamed(context, '/mine/bucket')
  );
}

Widget community(BuildContext context) {
  return CupertinoActionSheetAction(
    child: Text(
      '我的社区',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onPressed: () async {
      var url = 'mailto:cdr.today@foxmail.com?subject=hello';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  );
}

Widget author(BuildContext context) {
  return CupertinoActionSheetAction(
    child: Text(
      '联系作者',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onPressed: () async {
      var url = 'mailto:cdr.today@foxmail.com?subject=hello';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  );
}

Widget version(BuildContext context) {
  return  CupertinoActionSheetAction(
    child: Text(
      '版本信息',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subhead,
    ),
    onPressed: () => Navigator.popAndPushNamed(context, '/mine/version')
  );
}


// ----- actions -------
Widget blog() {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        return IconButton(
          icon: Icon(Icons.public),
          onPressed: () async {
            await launch('https://cdr.today/${state.name}');
          },
          color: Colors.black,
        );
      }
      return SizedBox.shrink();
    }
  );
}
