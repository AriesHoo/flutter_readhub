
import 'package:bot_toast/bot_toast.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_readhub/basis/basis_provider_widget.dart';
import 'package:flutter_readhub/manager/router_manger.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'generated/l10n.dart';
import 'observer/app_router_observer.dart';
import 'view_model/locale_view_model.dart';
import 'view_model/theme_view_model.dart';

void main() async {
  ///设置全屏
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();

  ///黑白化效果-缅怀
//  runApp(ColorFiltered(
//    colorFilter: ColorFilter.mode(Colors.white, BlendMode.color),
//    child: MyApp(),
//  ));
  ///初始化日志打印-使用LogUtil.v设置debug模式才打印
  LogUtil.init(
    tag: 'flutter_readhub',
    isDebug: true,
    maxLen: 1024,
  );
  runApp(
    MyApp(),
  );
}

///全局获取context
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

///全局路由监听-这里要设置Route基类
AppRouteObserver appRouteObserver = AppRouteObserver();

///全局toast
final botToastBuilder = BotToastInit();

///清空所有Toast
clearToast() {
  // BotToast.closeAllLoading();
  // BotToast.cleanAll();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialAppPage();
  }
}

///App入口
class MaterialAppPage extends StatefulWidget {
  @override
  _MaterialAppPageState createState() => _MaterialAppPageState();
}

class _MaterialAppPageState extends State<MaterialAppPage>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BasisProviderWidget2<ThemeViewModel, LocaleViewModel>(
      model1: ThemeViewModel(),
      model2: LocaleViewModel(),
      builder: (context, theme, locale, child) =>
          MaterialApp(

            ///后台管理器查看到标题
            title: 'Freadhub',

            ///用于全局获取Context
            navigatorKey: navigatorKey,

            ///全局常规主题配置
            theme: theme.themeData(),

            ///全局配置深色主题
            darkTheme: theme.themeData(platformDarkMode: true),

            ///是否显示右上顶部debug标签
            debugShowCheckedModeBanner: false,

            ///国际化语言
            locale: locale.locale,
            localizationsDelegates: [
              S.delegate,

              ///下拉刷新库国际化配置
              RefreshLocalizations.delegate,

              ///不配置该项会在EditField点击弹出复制粘贴工具时抛异常 The getter 'cutButtonLabel' was called on null.
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,

            ///配置页面路由
            onGenerateRoute: RouterManager.generateRoute,

            ///增加全局点击非输入框关闭软键盘--本项目不涉及软键盘,只做记录
            ///参考http://laomengit.com/blog/20200909/DismissKeyboard.html
            // builder: (context, child) => Scaffold(
            //   body: GestureDetector(
            //     onTap: () {
            //       FocusScopeNode currentFocus = FocusScope.of(context);
            //
            //       ///当前有获取焦点的控件
            //       if (!currentFocus.hasPrimaryFocus &&
            //           currentFocus.focusedChild != null) {
            //         ///关闭软键盘方式一
            //         FocusManager.instance.primaryFocus.unfocus();
            //
            //         ///关闭软键方式二-模拟器会关掉软键盘输入模式(模拟器不再弹出软键盘)除非重新在模拟器设置打开
            //         // SystemChannels.textInput.invokeMethod('TextInput.hide');
            //       }
            //     },
            //     child: child,
            //   ),
            // ),
            builder: (context, child) => botToastBuilder(context, child),

            ///路由监听
            navigatorObservers: [

              ///App本身的路由监听
              appRouteObserver,

              ///BotToast监听
              BotToastNavigatorObserver(),
            ],

            ///启动页显示slogan
            home: SplashPage(),
          ),
    );
  }

  @override
  void initState() {
    super.initState();

    ///添加监听用于监控前后台转换
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    LogUtil.v('didChangeAppLifecycleState:$state', tag: 'MaterialAppPage');

    ///应用前台-重新设置状态栏-主要针对暗黑模式有底部导航栏情况
    if (state == AppLifecycleState.resumed) {
      ThemeViewModel.setSystemBarTheme();
    }
  }
}

///增加一个闪屏页
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacementNamed(RouteName.tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme
          .of(context)
          .cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Image.asset(
            'assets/images/ic_logo_round.webp',
            width: 96,
            height: 96,
          ),
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/images/ic_slogan.webp',
            width: 205,
            height: 205 * 140 / 815,
            // color: Theme.of(context).textTheme.headline6!.color,
          ),
          SizedBox(
            height: 160,
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          SafeArea(
            bottom: PlatformUtil.isIOS,
            child: Image.asset(
              'assets/images/ic_powered.webp',
              width: 110,
              height: 110 * 100 / 436,
              // color: Theme.of(context).textTheme.headline6!.color,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
