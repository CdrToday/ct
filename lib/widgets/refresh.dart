import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cdr_today/blocs/refresh.dart';

class PostRefresh extends StatelessWidget {
  final Widget widget;

  PostRefresh({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if (state is PostRefreshStart) {
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

class CommunityRefresh extends StatelessWidget {
  final Widget widget;

  CommunityRefresh({ this.widget });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RefreshState>(
      builder: (context, state) {
        if (state is CommunityRefreshing) {
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
