import 'package:flutter/material.dart';

class CenterX extends StatelessWidget {
  final String x;
  CenterX({ this.x });

  Widget build(BuildContext context) {
    Widget _ctx;
    x == null ?
      _ctx = CircularProgressIndicator() :
      _ctx = Text(x);
    
    return Container(
      child: Center(child: _ctx),
      padding: EdgeInsets.only(bottom: kToolbarHeight)
    );
  }
}

class CenterS extends StatelessWidget {
  final String x;
  CenterS({ this.x });

  Widget build(BuildContext context) {
    Widget _ctx;
    x == null
    ? _ctx = CircularProgressIndicator()
    : _ctx = Text(x);
    
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => Container(
          child: Center(child: _ctx),
          padding: EdgeInsets.only(bottom: kToolbarHeight)
        ), childCount: 1
      )
    );
  }
}
