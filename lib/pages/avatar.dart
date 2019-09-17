import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/widgets/avatar.dart';
import 'package:cdr_today/widgets/alerts.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/widgets/actions.dart';

class Avatar extends StatelessWidget {
  var screenshotController = ScreenshotController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: avatarActions(context, screenshotController),
        leading: CloseButton(),
      ),
      body: Center(
        child: Container(
          color: Colors.brown.shade800,
          child: Screenshot(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserInited) {
                  if (state.avatar != null) {
                    return Image.network(conf['image'] + state.avatar);
                  } else if (state.name != null) {
                    return Center(
                      child: Text(
                        state.name[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 2,
                        )
                      )
                    );
                  } else {
                    return Center(
                      child: Text(
                        state.mail[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width / 2,
                        )
                      )
                    );
                  }
                }
              }
            ),
            controller: screenshotController,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(bottom: kToolbarHeight)
        )
      ),
    );
  }
}
