import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';

class CtThemeData {
  static CupertinoThemeData gen() {
    bool dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? true : false;
    // bool dark = darkMode(context);
    return CupertinoThemeData(
      
    );
  }
}
