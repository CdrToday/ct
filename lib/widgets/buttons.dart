import 'package:flutter/material.dart';

class Close extends StatelessWidget {
  final bool dark;
  Close({ this.dark = false });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.close,
        color: dark ? Colors.white : null,
      ),
      onTap: () => Navigator.maybePop(context),
    );
  }
}

class NoRipple extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;
  NoRipple({ this.icon, this.onTap });

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: GestureDetector(
        child: icon,
        onTap: onTap
      ),
      padding: EdgeInsets.all(12.0)
    );
  }
}
