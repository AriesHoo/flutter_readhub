import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_readhub/home_page.dart';
import 'package:flutter_readhub/view_model/update_model.dart';
import 'package:flutter_readhub/web_view_page.dart';
import 'package:flutter_readhub/widget/home_drawer_widget.dart';

class RouteName {
  static const String webView = 'webView';
  static const String setting = 'setting';
  static const String tab = 'tab';
}

///用于main MaterialApp配置 onGenerateRoute
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.tab:
        var model = settings.arguments as UpdateModel;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => HomePage(updateModel: model),
        );
      case RouteName.webView:
        var model = settings.arguments as String;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => WebViewPage(
            model,
          ),
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
