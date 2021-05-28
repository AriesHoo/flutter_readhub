import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_readhub/data/article_http.dart';
import 'package:flutter_readhub/dialog/author_dialog.dart';
import 'package:flutter_readhub/helper/provider_helper.dart';
import 'package:flutter_readhub/helper/string_helper.dart';
import 'package:flutter_readhub/main.dart';
import 'package:flutter_readhub/model/tab_model.dart';
import 'package:flutter_readhub/page/article_item_widget.dart';
import 'package:flutter_readhub/util/platform_util.dart';
import 'package:flutter_readhub/util/resource_util.dart';
import 'package:flutter_readhub/util/toast_util.dart';
import 'package:flutter_readhub/view_model/theme_view_model.dart';
import 'package:flutter_readhub/view_model/update_view_model.dart';
import 'package:flutter_readhub/widget/animated_switcher_icon_widget.dart';
import 'package:flutter_readhub/widget/tab_bar_widget.dart';

///主页面
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///tab标签
  List<TabModel> _listTab = [];
  TabController? _tabController;

  ///上次点击时间
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _listTab.add(
      TabModel(
        '热门话题',
        ArticleItemWidget(ArticleHttp.API_TOPIC),
      ),
    );
    _listTab.add(
      TabModel(
        '科技动态',
        ArticleItemWidget(ArticleHttp.API_NEWS),
      ),
    );
    _listTab.add(
      TabModel(
        '技术资讯',
        ArticleItemWidget(ArticleHttp.API_TECH_NEWS),
      ),
    );
    _listTab.add(
      TabModel(
        '区块链',
        ArticleItemWidget(ArticleHttp.API_BLOCK_CHAIN),
      ),
    );
    _tabController =
        TabController(initialIndex: 0, length: _listTab.length, vsync: this);

    ///非手机系统不做检测版本更新
    if (!PlatformUtil.isMobile) {
      return;
    }

    ///5s后进行版本检测
    Future.delayed(Duration(seconds: 5), () {
      UpdateViewModel().checkUpdate(context);
    });
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.v('home_page_didUpdateWidget');
  }

  @override
  Widget build(BuildContext context) {
    ///返回键控制
    return WillPopScope(
      onWillPop: () async {
        ///非手机不做拦截
        if (!PlatformUtil.isMobile) {
          return true;
        }
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                Duration(milliseconds: 1500)) {
          ///两次点击间隔超过阈值则重新计时
          _lastPressedAt = DateTime.now();
          ToastUtil.show(
            StringHelper.getS()!.quitApp,
            duration: Duration(milliseconds: 1500),
            notification: false,
          );
          return false;
        }
        exit(0);
        return true;
      },
      child: Stack(
        children: [
          // LayoutBuilder(
          //   builder: (context, constraints) {
          //     return KeepAliveWidget(
          //       child: HomeDesktopBody(
          //         _listTab,
          //         controller: _tabController,
          //       ),
          //     );
          //   },
          // ),
          HomeBody(
            _listTab,
            controller: _tabController,
          ),
          SplashPage(),
        ],
      ),
    );
  }
}

///主页面主体
class HomeBody extends StatelessWidget {
  const HomeBody(
    this.tabs, {
    Key? key,
    @required this.controller,
    this.onTap,
  }) : super(key: key);
  final List<TabModel> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: PreferredSize(
        ///设置AppBar高度
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Image.asset(
            'assets/images/title.png',
            width: 108,
            color: Theme.of(context).appBarTheme.iconTheme!.color,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            colorBlendMode: BlendMode.srcIn,
          ),
          actions: <Widget>[
            ///更多信息
            AnimatedSwitcherIconWidget(
              defaultIcon: Icons.info,
              switchIcon: Icons.info_outline,
              tooltip: StringHelper.getS()!.moreSetting,
              onPressed: () => showAuthorDialog(context),
              checkTheme: true,
            ),

            ///暗黑模式切换
            AnimatedSwitcherIconWidget(
              defaultIcon: Icons.brightness_2,
              switchIcon: Icons.brightness_5,
              tooltip: ThemeViewModel.darkMode
                  ? StringHelper.getS()!.lightMode
                  : StringHelper.getS()!.darkMode,
              onPressed: () => _switchDarkMode(context),
            ),
          ],
        ),
      ),

      ///内容区域
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ///tab栏
          Container(
            height: 36,
            width: double.infinity,

            ///添加该属性去掉Tab按下水波纹效果
            color: Theme.of(context).appBarTheme.color,

            ///TabBar
            child: TabBarWidget(
              labels: tabs.map((e) => e.label).toList(),
              controller: controller,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Decorations.lineBoxBorder(
                context,
                bottom: true,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: controller,
              children: List.generate(
                tabs.length,
                (i) => tabs[i].page,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///深色浅色模式切换
  void _switchDarkMode(BuildContext context) {
    if (ThemeViewModel.platformDarkMode) {
      ToastUtil.show(StringHelper.getS()!.tipSwitchThemeWhenPlatformDark);
    } else {
      ProviderHelper.of<ThemeViewModel>(context).switchTheme(
          userDarkMode: Theme.of(context).brightness == Brightness.light);
    }
  }
}

///大屏主页面
class HomeDesktopBody extends StatelessWidget {
  final List<TabModel> tabs;
  final TabController? controller;
  final ValueChanged<int>? onTap;

  const HomeDesktopBody(
    this.tabs, {
    Key? key,
    @required this.controller,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: Colors.pink,
          width: 200,
        ),
        Expanded(
          child: Expanded(
            flex: 1,
            child: HomeBody(
              tabs,
              controller: controller,
            ),
          ),
        )
      ],
    );
  }
}
