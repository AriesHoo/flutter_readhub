
import 'package:flustars/flustars.dart';
import 'package:flutter/widgets.dart';

///应用路由监听
class AppRouteObserver<R extends Route<dynamic>> extends RouteObserver<R> {
  String _tag = 'AppRouteObserver';

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    LogUtil.v(
        'didPush route: $route,previousRoute:$previousRoute,context:${route.navigator?.context}',
        tag: _tag);

    ///底部弹框不知为何会影响底部导航栏颜色
    // if (Platform.isAndroid) {
    //   LogUtil.v('push底部弹框', tag: _tag);
    //   Future.delayed(Duration(milliseconds: 500),
    //       () => ThemeViewModel.setSystemBarTheme());
    // }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    LogUtil.v('didPop route: $route,previousRoute:$previousRoute', tag: _tag);
    if (route is PageRoute) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    ///有从底部到顶部的Route会出现修改导航栏颜色问题-猜测是动画引起的
    // if (Platform.isAndroid) {
    //   LogUtil.v('pop底部弹框', tag: _tag);
    //   Future.delayed(Duration(milliseconds: 320),
    //       () => ThemeViewModel.setSystemBarTheme());
    // }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    LogUtil.v('didReplace newRoute: $newRoute,oldRoute:$oldRoute', tag: _tag);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    LogUtil.v('didRemove route: $route,previousRoute:$previousRoute',
        tag: _tag);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
    LogUtil.v('didStartUserGesture route: $route,previousRoute:$previousRoute',
        tag: _tag);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    LogUtil.v('didStopUserGesture', tag: _tag);
  }
}
