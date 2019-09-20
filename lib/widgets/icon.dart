import 'package:flutter/material.dart';

class IconHero extends StatelessWidget {
  final Icon icon;
  final String tag;
  final VoidCallback onTap;

  IconHero({ this.icon, this.tag, this.onTap });

  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        child: InkWell(
          child: icon,
          onTap: onTap,
        )
      ),
    );
  }
}
