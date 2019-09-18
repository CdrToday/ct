import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:cdr_today/x/conf.dart';
import 'package:cdr_today/blocs/user.dart';
import 'package:cdr_today/blocs/profile.dart';
import 'package:cdr_today/widgets/snackers.dart';
import 'package:cdr_today/widgets/actions.dart';

class Avatar extends StatelessWidget {
  final screenshotController = ScreenshotController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        actions: avatarActions(context, screenshotController),
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: Builder(
        builder: (context) => Center(
          child: Screenshot(
            child: Container(
              child: BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileAvatarUpdatedFailed) {
                    snacker(context, "头像修改失败，请重试");
                  } else if (state is ProfileAvatarUpdatedSucceed) {
                    Navigator.pop(context);
                  }
                },
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
                      }
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
                    return SizedBox.shrink();
                  }
                ),
              ),
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(bottom: kToolbarHeight * 1)
            ),
            controller: screenshotController,
          )
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
