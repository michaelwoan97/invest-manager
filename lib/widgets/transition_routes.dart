import 'package:flutter/material.dart';

/*
* class: TransitionRoutes
* purpose: this class is used for creating transition effects
* */
class TransitionRoutes extends PageRouteBuilder {
  final Widget page;

  TransitionRoutes({required this.page, required String routeName, Object? arguments})
      : super(
          settings: RouteSettings(name: routeName, arguments: arguments ?? [] ),
          pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation
          ) =>
              page,
          transitionsBuilder: (
          BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child
          ) => FadeTransition(opacity: animation, child: child),
    transitionDuration: Duration(milliseconds: 500),
  );


}


