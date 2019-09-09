import 'package:flutter/material.dart';

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  final Offset start;
  SlideRoute({this.page, this.start})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
    SlideTransition(
      position: Tween<Offset>(
        begin: start != null ? start : Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;
  SizeRoute({this.page})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
    Align(
      child: SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
    ),
  );
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) =>
    page,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) =>
    FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}

class RawRoute extends PageRouteBuilder {
  final Widget page;
  RawRoute({this.page})
  : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) => page
  );
}
