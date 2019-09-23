import 'package:flutter/material.dart';
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
