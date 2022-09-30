import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRouteObserver extends RouteObserver{
  void saveLastRoute(Route lastRoute) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_route', lastRoute.settings.name!);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // TODO: implement didPop
    saveLastRoute(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // TODO: implement didPush
    saveLastRoute(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    // TODO: implement didRemove
    saveLastRoute(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    // TODO: implement didReplace
    saveLastRoute(newRoute!);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}