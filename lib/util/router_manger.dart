import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/page/home_page.dart';
import 'package:flutter_readhub/page/web_view_page.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';

class RouteName {
  static const String web_view_page = 'web_view_page';
  static const String tab = 'tab';
}

///用于main MaterialApp配置 onGenerateRoute
class RouterManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.tab:
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => HomePage(),
        );
      case RouteName.web_view_page:
        var model = settings.arguments as String;
        return MaterialPageRoute(
//          fullscreenDialog: true,
          builder: (context) => WebViewPage(
            model,
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: Center(
                    child: Text(
                      'No route defined for ${settings.name}',
                      textScaleFactor: ThemeViewModel.textScaleFactor,
                    ),
                  ),
                ));
    }
  }
}
