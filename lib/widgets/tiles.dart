import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Widget title; 
  final Widget trailing;
  final VoidCallback onTap;
  final EdgeInsets margin;

  Tile({
      this.title,
      this.trailing,
      this.onTap,
      this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: title,
          trailing: trailing,
          onTap: onTap,
        )
      ),
      margin: margin ?? EdgeInsets.only(top: 10.0)
    );
  }
}

class BasicTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final EdgeInsets padding;
  BasicTile({ this.text, this.onTap, this.padding });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.0
            )
          ),
          onTap: onTap
        )
      ),
      padding: padding ?? EdgeInsets.all(16.0)
    );
  }
}
