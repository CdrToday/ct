import 'package:flutter/cupertino.dart';
import 'package:cdr_today/x/_style/color.dart';
import 'package:cdr_today/x/_style/text.dart';

/// # fontSize
/// largeTitle: 34.0
/// title: 28.0
class CtThemeData {
  static CupertinoThemeData gen() {
    return CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        textStyle: TextStyle(
          color: CtColors.primary,
          letterSpacing: 1.2
        ),
        navTitleTextStyle: TextStyle(
          color: CtColors.primary,
          fontSize: CtFontSize.headline
        ),
      ),
      barBackgroundColor: CtColors.gray5,
      scaffoldBackgroundColor: CtColors.gray5,
      primaryColor: CtColors.primary,
      primaryContrastingColor: CtColors.gray6
    );
  }
}
