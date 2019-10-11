import 'package:flutter/cupertino.dart';

bool darkMode(BuildContext context) {
  var qdarkMode = MediaQuery.of(context).platformBrightness;
  return qdarkMode == Brightness.dark ? true : false;
}

Color rgb(int r, int g, int b, {double o = 1.0}) {
  return Color.fromRGBO(r, g, b, o);
}

class CtColors {
  static var dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark
  ? true : false;

  static get primary => dark ? rgb(242, 242, 247) : rgb(28, 28, 30);
  static get blue => dark ? rgb(10, 232, 255) : rgb(0, 122, 255);
  static get green => dark ? rgb(48, 209, 88) : rgb(52, 199, 89);
  static get indigo => dark ? rgb(94, 92, 230) : rgb(88, 86, 214);
  static get orange => dark ? rgb(255, 159, 10) : rgb(255, 149, 0);
  static get pink => dark ? rgb(255, 55, 95) : rgb(255, 45, 85);
  static get purple => dark ? rgb(191, 90, 242) : rgb(175, 82, 222);
  static get red => dark ? rgb(255, 69, 58) : rgb(255, 59, 48);
  static get teal => dark ? rgb(100, 210, 255) : rgb(90, 200, 250);
  static get yellow => dark ? rgb(100, 210, 255) : rgb(90, 200, 250);
  static get gray => dark ? rgb(142, 142, 147) : rgb(142, 142, 147);
  static get gray2 => dark ? rgb(99, 99, 102) : rgb(174, 174, 178);
  static get gray3 => dark ? rgb(72, 72, 74) : rgb(199, 199, 204);
  static get gray4 => dark ? rgb(58, 58, 60) : rgb(209, 209, 214);
  static get gray5 => dark ? rgb(44, 44, 46) : rgb(229, 229, 234);
  static get gray6 => dark ? rgb(28, 28, 30) : rgb(242, 242, 247);
}
