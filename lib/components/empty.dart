import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Center(child: CircularProgressIndicator())
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

Widget emptyWidget(String text) {
  return Column(
    children: [
      Center(child: CircularProgressIndicator()),
      Center(
        child: Container(
          child: Text(text),
          margin: EdgeInsets.only(top: 10.0)
        )
      )
    ],
    mainAxisAlignment: MainAxisAlignment.center,
  );
}
