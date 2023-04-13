import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_readhub/main.dart';

///生命周期检测组件
///WidgetsBindingObserver--监控整个应用前后台状态
///RouteAware -监控路由栈
class LifecycleWidget extends StatefulWidget {
  final String tag = 'LifecycleWidget';
  final Widget? child;
  final WidgetLifecycleObserver? observer;
  final Function(WidgetLifecycleState)? onWidgetLifecycleChanged;
  final bool log;

  const LifecycleWidget({
    Key? key,
    @required this.child,
    this.observer,
    this.onWidgetLifecycleChanged,
    this.log = false,
  }) : super(key: key);

  @override
  _LifecycleWidgetState createState() => _LifecycleWidgetState();
}

class _LifecycleWidgetState extends State<LifecycleWidget>
    with WidgetsBindingObserver, RouteAware {
  ///整个app是否前台
  bool _isAppResumed = false;

  ///整个route是否前台
  bool _isRouteResumed = false;

  @override
  void initState() {
    super.initState();
    widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.created);
    widget.observer
        ?.didChangeWidgetLifecycleState(WidgetLifecycleState.created);

    ///初始化App状态
    _isAppResumed =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

    ///添加监听用于监控前后台转换
    WidgetsBinding.instance.addObserver(this);
    if (widget.log) {
      LogUtil.v('initState_state:${WidgetsBinding.instance.lifecycleState}',
          tag: widget.tag);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.destroyed);
    widget.observer
        ?.didChangeWidgetLifecycleState(WidgetLifecycleState.destroyed);

    ///移除路由监听
    appRouteObserver.unsubscribe(this);

    ///移除状态监听
    WidgetsBinding.instance.removeObserver(this);
    if (widget.log) {
      LogUtil.v('dispose', tag: widget.tag);
    }
  }

  ///应用前后台
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isAppResumed = state == AppLifecycleState.resumed;
    if (widget.log) {
      LogUtil.v('didChangeAppLifecycleState$state', tag: widget.tag);
    }

    ///Route在栈顶才有意义
    if (!_isRouteResumed) {
      return;
    }

    ///应用后台
    if (state == AppLifecycleState.paused) {
      widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.paused);
      widget.observer
          ?.didChangeWidgetLifecycleState(WidgetLifecycleState.paused);
    } else if (state == AppLifecycleState.resumed) {
      widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.resumed);
      widget.observer
          ?.didChangeWidgetLifecycleState(WidgetLifecycleState.resumed);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///订阅路由监听
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPushNext() {
    super.didPushNext();
    if (_isAppResumed) {
      widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.paused);
      widget.observer
          ?.didChangeWidgetLifecycleState(WidgetLifecycleState.paused);
    }
    _isRouteResumed = false;
    if (widget.log) {
      LogUtil.v('didPushNext:进入下一个Route当前进入后台', tag: widget.tag);
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    if (_isAppResumed) {
      widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.resumed);
      widget.observer
          ?.didChangeWidgetLifecycleState(WidgetLifecycleState.resumed);
    }
    _isRouteResumed = true;
    if (widget.log) {
      LogUtil.v('didPopNext:回到当前Route', tag: widget.tag);
    }
  }

  @override
  void didPush() {
    super.didPush();
    if (_isAppResumed) {
      widget.onWidgetLifecycleChanged?.call(WidgetLifecycleState.resumed);
      widget.observer
          ?.didChangeWidgetLifecycleState(WidgetLifecycleState.resumed);
    }
    _isRouteResumed = true;
    if (widget.log) {
      LogUtil.v('didPush:刚进入当前Route', tag: widget.tag);
    }
  }

  @override
  void didPop() {
    super.didPop();
    if (_isAppResumed) {
      widget.onWidgetLifecycleChanged
          ?.call(WidgetLifecycleState.beforeDestroyed);
      widget.observer
          ?.didChangeWidgetLifecycleState(WidgetLifecycleState.beforeDestroyed);
    }
    _isRouteResumed = false;
    if (widget.log) {
      LogUtil.v('didPop:即将pop出Route栈', tag: widget.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

///View生命周期状态
enum WidgetLifecycleState {
  ///创建-initState
  created,

  ///恢复-获取焦点;App进入前台且当前路由回到顶部
  resumed,

  ///暂停-失去焦点;App进入后台或当前路由push到新路由
  paused,

  ///销毁前-didPop
  beforeDestroyed,

  ///销毁-dispose
  destroyed,
}

///View生命周期观察者
class WidgetLifecycleObserver {
  void didChangeWidgetLifecycleState(WidgetLifecycleState state) {}
}
