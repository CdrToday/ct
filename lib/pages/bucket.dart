import 'package:flutter/material.dart';
import 'package:cdr_today/pages/post.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class Bucket extends StatelessWidget {
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文章管理'),
        leading: CloseButton(),
        actions: [ blog() ],
      ),
      body: Post(edit: true)
    );
  }  
}

Widget blog() {
  return BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      if (state is UserInited) {
        return IconButton(
          icon: Icon(Icons.explore),
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
