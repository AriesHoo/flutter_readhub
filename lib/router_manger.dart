import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RouteName {
  static const String webView = 'webView';
  static const String login = 'login';
  static const String register_first_step = 'register_first_step';
  static const String register = 'register';
  static const String movie = 'movie';
}

///用于main MaterialApp配置 onGenerateRoute
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
