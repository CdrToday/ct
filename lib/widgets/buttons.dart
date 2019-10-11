import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';

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
  final EdgeInsets padding;
  NoRipple({ this.icon, this.onTap, this.padding });

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: GestureDetector(
        child: icon,
        onTap: onTap
      ),
      padding: padding ?? EdgeInsets.all(12.0)
    );
  }
}

class CtNoRipple extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final EdgeInsets padding;
  CtNoRipple({ this.icon, this.onTap, this.padding });

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: GestureDetector(
        child: Icon(icon, size: 22.0),
        onTap: onTap
      ),
      padding: padding ?? EdgeInsets.all(0.0)
    );
  }
}

class CtOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  CtOutlineButton({ this.text, this.onTap });

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(
        text,
        style: TextStyle(color: CtColors.primary)
      ),
      onPressed: onTap,
      borderSide: BorderSide(color: CtColors.gray2),
      highlightColor: CtColors.gray5,
      highlightedBorderColor: CtColors.gray,
    );
  }
}

class CtBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CtNoRipple(
      icon: CupertinoIcons.back,
      onTap: () => Navigator.pop(context),
    );
  }
}

class CtClose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CtNoRipple(
      icon: CupertinoIcons.clear_circled,
      onTap: () => Navigator.maybePop(context),
    );
  }
}
