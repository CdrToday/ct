import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';

class CtThemeData {
  static CupertinoThemeData gen() {
    // bool dark = darkMode(context);
    print(CtColors.green);
    return CupertinoThemeData(
      scaffoldBackgroundColor: CtColors.gray5,
    );
  }
}
