import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:shared_preferences/shared_preferences.dart';

// purpose: the purpose of this class is to observe the change
//          in route stack and apply logic accordingly
class MyRouteObserver extends RouteObserver {
  void saveLastRoute(Route lastRoute) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(lastRoute.settings.name == null){
      return;
    }
    prefs.setString('last_route', lastRoute.settings.name!);

    // check whether there are arguments in the route
    // if(lastRoute.settings.arguments != null){
    // check route
    if (lastRoute.settings.name == AddStock.routeName) {
      if(lastRoute.settings.arguments == null || (lastRoute.settings.arguments as List).isEmpty){
        return;
      }
      final data = lastRoute.settings.arguments as List;
      String scenario = EnumToString.convertToString(data[1] as Scenarios);
      prefs.setString('sneaker', jsonEncode(data[0]));
      prefs.setString('scenario', scenario);
    }
  }

  // purpose: delete the route that has arguments when popping
  deleteArguments(String routeName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // check whether it is popping the add-stock route with arguments
    if (routeName == AddStock.routeName) {
      if(prefs.containsKey("sneaker") && prefs.containsKey("scenario")){
        prefs.remove("sneaker");
        prefs.remove("scenario");
      }

    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    // TODO: implement didPop
    saveLastRoute(previousRoute!);

    if(route.settings.name != null){
      deleteArguments(route.settings.name!);
    }


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
