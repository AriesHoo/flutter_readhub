import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_readhub/widget/web_view_widget.dart';

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
      case RouteName.webView:
        var model = settings.arguments as String;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => WebViewPage(model,),
        );
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
