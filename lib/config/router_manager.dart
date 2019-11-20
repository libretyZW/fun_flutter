import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_flutter/ui/page/tab_navigator.dart';
import 'package:fun_flutter/ui/widget/page_route_anim.dart';

class RouterName {
  static const String tab = '/';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouterName.tab:
        return NoAnimRouteBuilder(TabNavigator());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${routeSettings.name}'),
                  ),
                ));
    }
  }
}
