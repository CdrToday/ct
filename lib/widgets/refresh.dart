import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';

class PostRefresher extends StatelessWidget {
  final Widget widget;
  PostRefresher({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).post == true) {
          return CupertinoActivityIndicator();
        }
        return widget ?? SizedBox.shrink();
      }
    );
  }
}

class CommunityRefresher extends StatelessWidget {
  final Widget widget;
  CommunityRefresher({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).community == true) {
          return Container(
            child: SizedBox(
              height: 12.0,
              width: 12.0,
              child: CircularProgressIndicator(strokeWidth: 1.0)
            ),
          );
        }
        return widget ?? SizedBox.shrink();
      }
    );
  }
}

class RedditRefresher extends StatelessWidget {
  final Widget widget;
  RedditRefresher({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).reddit == true) {
          return CupertinoActivityIndicator();
        }
        return widget ?? SizedBox.shrink();
      }
    );
  }
}

class EditRefresher extends StatelessWidget {
  final bool empty;
  final Widget widget;
  EditRefresher({ this.empty = false, this.widget });
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).edit) {
          if (empty == true) return SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CupertinoActivityIndicator(),
          );
        }

        return widget;
      }
    );
  }
}

class ProfileRefresher extends StatelessWidget {
  final Widget widget;
  ProfileRefresher({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).profile == true) {
          return Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CupertinoActivityIndicator(),
          );
        }
        return widget ?? SizedBox.shrink();
      }
    );
  }
}

class AuthorRefresher extends StatelessWidget {
  final Widget widget;
  AuthorRefresher({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).author == true) {
          return CupertinoActivityIndicator();
        }
        return widget ?? SizedBox.shrink();
      }
    );
  }
}

class QrRefresher extends StatelessWidget {
  final Widget widget;
  QrRefresher({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if ((state as Refresher).qr == true) {
          return Container(
            child: SizedBox(
              height: 16.0,
              width: 16.0,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
              )
            ),
          );
        }
        return widget ?? SizedBox.shrink();
      }
    );
  }
}
