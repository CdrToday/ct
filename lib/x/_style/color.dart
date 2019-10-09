import 'package:flutter/cupertino.dart';

bool darkMode(BuildContext context) {
  var qdarkMode = MediaQuery.of(context).platformBrightness;
  return qdarkMode == Brightness.dark ? true : false;
}

Color rgb(int r, int g, int b, {double o = 1.0}) {
  return Color.fromRGBO(r, g, b, o);
}

class CtColors {
  bool dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? true : false;
  Color green;
  Color indigo;
  Color orange;
  Color pink;
  Color purple;
  Color red;
  Color teal;
  Color yellow;
  Color gray;
  Color gray2;
  Color gray3;
  Color gray4;
  Color gray5;
  Color gray6;
}

class CtColorsScheme {}

class CtColorsLight extends CtColorsScheme {
  static get blue => rgb(0, 122, 255);
  Color green = rgb(52, 199, 89);
  Color indigo = rgb(88, 86, 214);
  Color orange = rgb(255, 149, 0);
  Color pink = rgb(255, 45, 85);
  Color purple = rgb(175, 82, 222);
  Color red = rgb(255, 39, 48);
  Color teal = rgb(90, 200, 250);
  Color yellow = rgb(255, 204, 0);
  Color gray = rgb(142, 142, 147);
  Color gray2 = rgb(174, 174, 178);
  Color gray3 = rgb(199, 199, 204);
  Color gray4 = rgb(209, 209, 214);
  Color gray5 = rgb(229, 229, 214);
  Color gray6 = rgb(242, 242, 247);
}

class CtColorsDark extends CtColorsScheme {
  Color blue = rgb(10, 232, 255);
  Color green = rgb(48, 209, 88);
  Color indigo = rgb(94, 92, 230);
  Color orange = rgb(255, 159, 10);
  Color pink = rgb(255, 55, 95);
  Color purple = rgb(191, 90, 242);
  Color red = rgb(255, 69, 58);
  Color teal = rgb(100, 210, 255);
  Color yellow = rgb(255, 214, 10);
  Color gray = rgb(142, 142, 147);
  Color gray2 = rgb(99, 99, 102);
  Color gray3 = rgb(72, 72, 74);
  Color gray4 = rgb(58, 58, 60);
  Color gray5 = rgb(44, 44, 46);
  Color gray6 = rgb(28, 28, 30);
}
