import 'package:flutter/material.dart';
import 'package:cdr_today/x/_style/color.dart';

// settings
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

// profile
class ProfileTile extends StatelessWidget {
  final VoidCallback onTap;
  final String leading;
  final Widget trailing;
  final double height;
  
  ProfileTile({ this.onTap, this.leading, this.trailing, this.height });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          leading,
          style: TextStyle(color: CtColors.primary),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
      color: CtColors.gray6,
      elevation: 0.0,
      shape: BeveledRectangleBorder(),
      margin: EdgeInsets.all(0.0)
    );
  }
}

class CtDivider extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      child: Divider(
        height: 0.1,
        indent: 24.0,
      ),
      color: CtColors.gray
    );
  }
}
